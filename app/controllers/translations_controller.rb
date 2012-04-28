# -*- encoding : utf-8 -*-
class TranslationsController < ApplicationController
  autocomplete :employee, :name
  
  def show
    @translation = Translation.find(params[:id])
    @comment = Comment.new
  end
  
  def edit
    @translation = Translation.find(params[:id])
  end
  
  def update
    @translation = Translation.find(params[:id])
    if @translation.update_attributes(params[:translation])
      redirect_to(@translation, :notice => '更新成功')
    else
      render :action => "edit"
    end
  end
  
  def download
    @translation = Translation.find(params[:id])
    send_file @translation.file.stored_path, :filename => @translation.human_file_name
  end
  
  def generated
    @translations = Translation.generated.paginate :page => params[:page]
  end
  
  def assigned
    if user_role_in_session == User::ROLE_ASSIGNEE
      @translations = Translation.assigned.assigned_for(user_id_in_session).paginate :page => params[:page]
    else
      @translations = Translation.assigned.paginate :page => params[:page]
    end
  end
  
  def sent
    if user_role_in_session == User::ROLE_ASSIGNEE
      @translations = Translation.sent.assigned_for(user_id_in_session).paginate :page => params[:page]
    else
      @translations = Translation.sent.paginate :page => params[:page]
    end
  end
  
  def translated
    if user_role_in_session == User::ROLE_ASSIGNEE
      @translations = Translation.translated.assigned_for(user_id_in_session).paginate :page => params[:page]
    else
      @translations = Translation.translated.paginate :page => params[:page]
    end
  end
  
  def approved
    if user_role_in_session == User::ROLE_ASSIGNEE
      @translations = Translation.approved.assigned_for(user_id_in_session).paginate :page => params[:page]
    else
      @translations = Translation.approved.paginate :page => params[:page]
    end
  end
  
  def finished
    if user_role_in_session == User::ROLE_EDITOR
      @translations = Translation.finished.paginate :page => params[:page]
    elsif user_role_in_session == User::ROLE_ASSIGNEE
      @translations = Translation.finished.assigned_for(user_id_in_session).paginate :page => params[:page]
    else
      @translations = Translation.finished.paginate :page => params[:page]
    end
  end
  
  def batch_assign
    @translations = Translation.generated
    if request.post?
      path = params[:searched] ? search_generated_translations_path : batch_assign_translations_path
      if params[:translation_ids].blank?
        redirect_to path, :alert => '操作失败，请至少选择一个外文文档！'
      elsif params[:assignee_id].blank?
        redirect_to path, :alert => '操作失败，请选择指派人！'
      else
        Translation.batch_assign user_id_in_session, params[:translation_ids], params[:assignee_id]
        redirect_to path, :notice => '批量指派成功'
      end
    end
  end
  
  def batch_archive
    if user_role_in_session == User::ROLE_ASSIGNEE
      @translations = Translation.assigned.assigned_for user_id_in_session
    else
      @translations = Translation.assigned
    end
    if request.post?
      if params[:translation_ids].blank?
        redirect_to (params[:searched] ? search_assigned_translations_path : batch_archive_translations_path), :alert => '操作失败，请至少选择一个外文文档！'
      else
        archive_name = Translation.batch_archive user_id_in_session, params[:translation_ids]
        send_file "#{::Rails.root.to_s}/public/archives/#{archive_name}", :filename => archive_name, :type => 'application/octet-stream'
      end
    end
  end
  
  def batch_upload
    if request.post?
      if params[:file].blank?
        redirect_to batch_upload_translations_path, :alert => '请正确选择文件'
      elsif params[:file].content_type != 'application/octet-stream'
        redirect_to batch_upload_translations_path, :alert => '请选择RAR文件，其它格式的文件无法提交'
      else
        @unknown_files = Translation.batch_upload user_id_in_session, params[:file].read
        if @unknown_files.blank?
          redirect_to batch_upload_translations_path, :notice => '批量上传翻译文档成功'
        else
          render 'batch_upload_result'
        end
      end
    end
  end
  
  def batch_approve
    @translations = Translation.translated
    if request.post?
      if params[:translation_ids].blank?
        redirect_to batch_approve_translations_path, :alert => '操作失败，请至少选择一个外文文档！'
      else
        Translation.batch_approve user_id_in_session, params[:translation_ids]
        redirect_to batch_approve_translations_path, :notice => '批量审核成功'
      end
    end
  end
  
  def batch_archive_approved
    @translations = Translation.approved
    if request.post?
      if params[:translation_ids].blank?
        redirect_to (params[:searched] ? search_approved_translations_path : batch_archive_translations_path), :alert => '操作失败，请至少选择一个外文文档！'
      else
        archive_name = Translation.batch_archive user_id_in_session, params[:translation_ids]
        send_file "#{::Rails.root.to_s}/public/archives/#{archive_name}", :filename => archive_name, :type => 'application/octet-stream'
      end
    end
  end
  
  def batch_archive_finished
    @translations = Translation.approved
    if request.post?
      if params[:translation_ids].blank?
        redirect_to (params[:searched] ? search_approved_translations_path : batch_archive_translations_path), :alert => '操作失败，请至少选择一个外文文档！'
      else
        archive_name = Translation.batch_archive user_id_in_session, params[:translation_ids]
        send_file "#{::Rails.root.to_s}/public/archives/#{archive_name}", :filename => archive_name, :type => 'application/octet-stream'
      end
    end
  end
  
  def search
    unless params[:keywords].blank?
      @translations = Translation.search(params[:keywords]).paginate :page => params[:page]
      render 'search_result'
    end
  end
  
  def search_generated
    if request.get?
      render 'translations/search/generated'
    else
      @translations = Translation.advanced_search Translation::STATE_GENERATED, params
      render 'translations/search/generated_result'
    end
  end
  
  def search_assigned
    if request.get?
      render 'translations/search/assigned'
    else
      @translations = Translation.advanced_search Translation::STATE_ASSIGNED, params
      render 'translations/search/assigned_result'
    end
  end
  
  def search_approved
    if request.get?
      render 'translations/search/approved'
    else
      @translations = Translation.advanced_search Translation::STATE_APPROVED, params
      render 'translations/search/approved_result'
    end
  end
  
  def search_finished
    if request.get?
      render 'translations/search/finished'
    else
      @translations = Translation.advanced_search Translation::STATE_FINISHED, params
      render 'translations/search/finished_result'
    end
  end
end