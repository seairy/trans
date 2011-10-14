# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base
  acts_as_nested_set
  has_many :documents
  has_many :translations, :through => :documents, :source => :document
  before_create :setup_position
  
  def setup_position
    self.position = Category.where(self.parent_id.blank? ? 'parent_id IS NULL' : ['parent_id = ?', self.parent_id]).maximum('position').to_i + 1
  end
end

