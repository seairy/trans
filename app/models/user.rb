# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  ROLE_ADMIN, ROLE_CIO_MANAGER, ROLE_EDITOR, ROLE_HF_MANAGER, ROLE_ASSIGNEE = 1, 2, 3, 4, 5  
  attr_accessor :password
  before_create :generate_hashed_password
  validates_presence_of :account, :password, :password_confirmation, :on => :create
  validates_length_of :account, :password, :password_confirmation,:in => 4..16, :on => :create
  validates_uniqueness_of :account, :on => :create
  validates_confirmation_of :password, :on => :create
  scope :editors, where(role:ROLE_EDITOR)
  scope :assignee, where(role:ROLE_ASSIGNEE)
  
  def generate_hashed_password
    self.hashed_password = Digest::MD5.hexdigest self.password
  end
  
  class << self
    def signin account, password
      self.find_by_account_and_hashed_password account, Digest::MD5.hexdigest(password)
    end
  end
end

