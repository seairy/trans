# -*- encoding : utf-8 -*-
class Translation < ActiveRecord::Base
  STATE_GENERATED, STATE_ASSIGNED, STATE_SENT, STATE_TRANSLATED, STATE_APPROVED, STATE_FINISHED = 1, 2, 3, 4, 5, 6
  belongs_to :document
  belongs_to :language
  belongs_to :file, :class_name => 'Asset'
  belongs_to :owner, :class_name => 'User'
  belongs_to :assignee, :class_name => 'User'
  belongs_to :linguister, :class_name => 'Employee'
  belongs_to :embellisher, :class_name => 'Employee'
  belongs_to :reader, :class_name => 'Employee'
  belongs_to :editor, :class_name => 'Employee'
  has_many :operations
  has_many :comments
  scope :generated, where(:state => STATE_GENERATED).includes(:document).includes(:language)
  scope :assigned, where(:state => STATE_ASSIGNED).includes(:document).includes(:language).includes(:assignee)
  scope :sent, where(:state => STATE_SENT).includes(:document).includes(:language).includes(:assignee)
  scope :translated, where(:state => STATE_TRANSLATED).includes(:document).includes(:language).includes(:file).includes(:assignee)
  scope :approved, where(:state => STATE_APPROVED).includes(:document).includes(:language).includes(:file).includes(:assignee)
  scope :finished, where(:state => STATE_FINISHED).includes(:document).includes(:language).includes(:file).includes(:assignee)
  scope :owned_for, lambda {|owner| where(owner_id:owner)}
  scope :assigned_for, lambda {|assignee| where(assignee_id:assignee)}
  scope :search, lambda {|keywords| includes(:document).where('translations.id = ? OR documents.title LIKE ?', keywords, "%#{keywords}%")}
  
  def translated_at
    includes(:operations).where('operations.action = ?', Operation::ACTION_UPLOAD_AND_TRANSLATE).order('operations.created_at DESC').first
  end
  
  class << self
    def batch_assign user_id, translation_ids, assignee_id
      translation_ids.each do |translation_id|
        translation = find(translation_id)
        if translation.state == STATE_GENERATED
          translation.update_attribute(:state, STATE_ASSIGNED)
          translation.update_attribute(:assignee_id, assignee_id)
          Operation.create({ :translation_id => translation.id, :user_id => user_id, :action => Operation::ACTION_ASSIGN })
        end
      end
    end
    
    def batch_archive user_id, translation_ids
      archive_name = "archive_#{Time.now.strftime('%Y_%m_%d_%H_%M_%S')}_#{rand.to_s[-8..-1]}"
      FileUtils.mkdir_p "#{::Rails.root.to_s}/public/archives/#{archive_name}"
      translations = Translation.find(translation_ids)
      translations.each do |t|
        if t.state == STATE_ASSIGNED
          t.update_attribute(:state, STATE_SENT)
          Operation.create({ :translation_id => t.id, :user_id => user_id, :action => Operation::ACTION_ARCHIVE_AND_SENT })
        elsif t.state == STATE_APPROVED
          t.update_attribute(:state, STATE_FINISHED)
          Operation.create({ :translation_id => t.id, :user_id => user_id, :action => Operation::ACTION_ARCHIVE_AND_FINISH })
        end
        FileUtils.copy t.document.file.stored_path, "#{::Rails.root.to_s}/public/archives/#{archive_name}/#{t.id}_#{t.created_at.strftime '%Y%m%d'}_#{t.language.name}_#{t.document.title}#{t.document.file.stored_name.scan(/\.\w+$/)[0]}"
      end
      system "cd #{::Rails.root.to_s}/public/archives; rar a #{archive_name}.rar #{archive_name}"
      FileUtils.rm_rf "#{::Rails.root.to_s}/public/archives/#{archive_name}"
      "#{archive_name}.rar"
    end
    
    def batch_upload user_id, input_stream
      unknown_files = []
      tmp_filename = "tmp_#{Time.now.strftime('%Y_%m_%d_%H_%M_%S')}_#{rand.to_s[-8..-1]}"
      File.open("#{::Rails.root.to_s}/public/temp/#{tmp_filename}", "wb") {|f| f.write(input_stream)}
      FileUtils.mkdir_p "#{::Rails.root.to_s}/public/temp/#{tmp_filename}_dir"
      system "unrar x -inul -y #{::Rails.root.to_s}/public/temp/#{tmp_filename} #{::Rails.root.to_s}/public/temp/#{tmp_filename}_dir/"
      Dir.entries("#{::Rails.root.to_s}/public/temp/#{tmp_filename}_dir").each do |path|
        if path != '.' && path != '..'
          begin
            translation = Translation.find(path.split('_')[0])
          rescue ActiveRecord::RecordNotFound
            unknown_files << path
          else
            if translation.state == Translation::STATE_SENT or translation.state == Translation::STATE_TRANSLATED
              file = File.open("#{::Rails.root.to_s}/public/temp/#{tmp_filename}_dir/#{path}")
              asset = Asset.new.prepare({ :stream => file.read, :original_filename => path, :content_type => 'application/msword', :size => file.size })
              asset.save
              translation.file.destory unless translation.file.blank?
              translation.file = asset
              translation.state = Translation::STATE_TRANSLATED
              translation.save
              Operation.create({ :translation_id => translation.id, :user_id => user_id, :action => Operation::ACTION_UPLOAD_AND_TRANSLATE })
            end
          end
        end
      end
      FileUtils.rm_r "#{::Rails.root.to_s}/public/temp/#{tmp_filename}"
      FileUtils.rm_rf "#{::Rails.root.to_s}/public/temp/#{tmp_filename}_dir"
      unknown_files
    end
    
    def batch_approve user_id, translation_ids
      translation_ids.each do |translation_id|
        translation = find(translation_id)
        if translation.state == STATE_TRANSLATED
          translation.update_attribute(:state, STATE_APPROVED)
          Operation.create({ :translation_id => translation.id, :user_id => user_id, :action => Operation::ACTION_APPROVE })
        end
      end
    end
    
    def search_approved category_id, keywords, language_ids, date_range
      result = where(state:STATE_APPROVED)
      result = result.includes(:document).where(:'documents.category_id' => category_id) unless category_id.blank?
      result = result.includes(:document).where('translations.id = ? OR documents.title LIKE ?', keywords, "%#{keywords}%") unless keywords.blank?
      unless language_ids.blank?
        result = result.includes(:language).where(id:language_ids)
      end
      if Date.valid_civil?(date_range[:'begin(1i)'].to_i,date_range[:'begin(2i)'].to_i,date_range[:'begin(3i)'].to_i)
        result = result.includes(:operations).where(:'operations.action' => Operation::ACTION_UPLOAD_AND_TRANSLATE).where('operations.created_at >= ?', Date.new(date_range[:'begin(1i)'].to_i,date_range[:'begin(2i)'].to_i,date_range[:'begin(3i)'].to_i).at_beginning_of_day)
      end
      if Date.valid_civil?(date_range[:'end(1i)'].to_i,date_range[:'end(2i)'].to_i,date_range[:'end(3i)'].to_i)
        result = result.includes(:operations).where(:'operations.action' => Operation::ACTION_UPLOAD_AND_TRANSLATE).where('operations.created_at <= ?', Date.new(date_range[:'end(1i)'].to_i,date_range[:'end(2i)'].to_i,date_range[:'end(3i)'].to_i))
      end
      result
    end
  end
end