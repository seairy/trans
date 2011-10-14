# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  before_filter :authorize
  before_filter :unread_notices_count
  
  protected
  def user_id_in_session
    session[:user_id]
  end
  
  def user_role_in_session
    session[:user_role]
  end
  
  def signined?
    !session[:user_id].blank?
  end
  
  def authorize
    unless signined?
      redirect_to signin_path
    end
  end
  
  def unread_notices_count
    @unread_notices_count = Notice.where(user_id:user_id_in_session).count
  end
  
  def store_uploaded_data uploaded_data, options = {}
    if uploaded_data.blank?
      raise ArgumentError, 'Missing uploaded data'
    elsif !options[:accepted_mime_types].blank? and !options[:accepted_mime_types].include? uploaded_data.content_type
      raise ArgumentError, 'Mismatch mime type'
    else
      asset = Asset.new.prepare({ :stream => uploaded_data.read, :original_filename => uploaded_data.original_filename, :content_type => uploaded_data.content_type, :size => uploaded_data.size })
      asset.save
      asset
    end
  end
end

