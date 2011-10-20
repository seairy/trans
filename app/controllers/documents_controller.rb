# -*- encoding : utf-8 -*-
class DocumentsController < ApplicationController
  
  def index
    @documents = Document.paginate :page => params[:page]
  end
  
  def show
    @document = Document.find(params[:id])
  end
  
  def new
    @document = Document.new
  end
  
  def edit
    @document = Document.find(params[:id])
  end
  
  def create
    if params[:language_ids].blank?
      redirect_to new_documents_path, :alert => '操作失败，请至少选择一种翻译语言！'
    else
      @document = Document.new(params[:document])
      @document.uploader_id = user_id_in_session
      @document.state = Document::STATE_UPLOADED
      if @document.save
        @document.file = store_uploaded_data(params[:uploaded_data])
        @document.save
        Document.assign user_id_in_session, [@document.id], params[:language_ids]
        redirect_to(@document, :notice => '创建成功')
      else
        render :action => "new"
      end
    end
  end
  
  def batch_create
    if params[:file].blank?
      redirect_to batch_new_documents_path, :alert => '请正确选择文件'
    elsif params[:file].content_type != 'application/octet-stream'
      redirect_to batch_new_documents_path, :alert => '请选择RAR文件，其它格式的文件无法提交'
    else
      @tmp_filename = "tmp_#{Time.now.strftime('%Y_%m_%d_%H_%M_%S')}_#{rand.to_s[-8..-1]}"
      File.open("#{::Rails.root.to_s}/public/temp/#{@tmp_filename}", "wb") do |f|
        f.write(params[:file].read)
      end
      FileUtils.mkdir_p "#{::Rails.root.to_s}/public/temp/#{@tmp_filename}_dir"
      system "unrar x -inul -y #{::Rails.root.to_s}/public/temp/#{@tmp_filename} #{::Rails.root.to_s}/public/temp/#{@tmp_filename}_dir/"
      @categories_list = []
      iterate_file "#{::Rails.root.to_s}/public/temp/#{@tmp_filename}_dir"
      FileUtils.rm_r "#{::Rails.root.to_s}/public/temp/#{@tmp_filename}"
      FileUtils.rm_rf "#{::Rails.root.to_s}/public/temp/#{@tmp_filename}_dir"
      redirect_to batch_new_documents_path, :notice => '批量添加文档成功'
    end
  end
  
  def update
    @document = Document.find(params[:id])
    if @document.update_attributes(params[:document])
      unless params[:uploaded_data].blank?
        @document.file = store_uploaded_data(params[:uploaded_data])
        @document.save
      end
      redirect_to(@document, :notice => '更新成功')
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @document = Document.find(params[:id])
    if @document.translations.size > 0
      redirect_to @document, :alert => "该文档已进行#{@document.translations.collect{|t| t.language.name}.join '、'}翻译，请先删除以上文档后再试！"
    else
      @category.destroy
      redirect_to documents_path, :notice => '删除成功'
    end
  end
  
  def uploaded
    @documents = Document.uploaded.paginate :page => params[:page]
  end
  
  def batch_assign
    @documents = Document.uploaded
    if request.post?
      if params[:document_ids].blank?
        redirect_to batch_assign_documents_path, :alert => '操作失败，请至少选择一个中文文档！'
      elsif params[:language_ids].blank?
        redirect_to batch_assign_documents_path, :alert => '操作失败，请至少选择一种翻译语言！'
      else
        Document.assign user_id_in_session, params[:document_ids], params[:language_ids], params[:priority]
        redirect_to batch_assign_documents_path, :notice => '批量指派成功'
      end
    end
  end
  
  protected
  def iterate_file(prefix)
    Dir.entries(prefix).each do |path|
      if path != '.' && path != '..'
        if File.directory?("#{prefix}/#{path}")
          category_name = path.gsub(/^\d+\./, '')
          categories = Category.where(:parent_id => @categories_list.blank? ? nil : @categories_list.last[:id], :name => category_name)
          if categories.size == 1
            @categories_list << { :id => categories.first.id, :name => category_name, :path => path }
          else
            @categories_list << { :id => Category.create({ :parent_id => @categories_list.blank? ? nil : @categories_list.last[:id], :name => category_name }).id, :name => category_name, :path => path }
          end
          iterate_file("#{prefix}/#{path}")
        else
          file = File.open("#{::Rails.root.to_s}/public/temp/#{@tmp_filename}_dir/#{@categories_list.map{|c| c[:path]}.join '/'}/#{path}")
          asset = Asset.new.prepare({ :stream => file.read, :original_filename => path, :content_type => 'application/msword', :size => file.size })
          asset.save
          document_title = path.gsub(/\.\w+$/, '')
          word_count = (title.scan(/_(\d+)\./)[0][0] unless title.scan(/_(\d+)\./).blank?) || 0
          Document.create({ :category_id => @categories_list.blank? ? nil : @categories_list.last[:id], :uploader_id => user_id_in_session, :file => asset, :title => document_title, :word_count => word_count, :priority => 0, :state => Document::STATE_UPLOADED })
        end
      end
    end
    @categories_list.pop
  end
end