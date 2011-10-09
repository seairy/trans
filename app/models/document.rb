# -*- encoding : utf-8 -*-
class Document < ActiveRecord::Base
  STATE_UPLOADED, STATE_ASSIGNED = 1, 2
  belongs_to :category
  belongs_to :uploader, :class_name => 'User'
  belongs_to :file, :class_name => 'Asset'
  has_many :comments
  has_many :operations
  has_many :translations
  scope :uploaded, where(:state => STATE_UPLOADED).includes(:category)
  
  class << self
    def assign user_id, document_ids, language_ids, priority = nil
      document_ids.each do |document_id|
        document = find(document_id)
        if document.state == STATE_UPLOADED
          language_ids.each do |language_id|
            translation = Translation.create({ :document_id => document_id, :language_id => language_id, :state => Translation::STATE_GENERATED})
            Operation.create({ :translation_id => translation.id, :user_id => user_id, :action => Operation::ACTION_GENERATE})
          end
          document.update_attribute(:state, STATE_ASSIGNED)
          document.update_attribute(:priority, priority) unless priority.blank?
        end
      end
    end
  end
end