# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController
  skip_before_filter :authorize
  
  def new
    
  end
  
  def create
    user = User.signin params[:account], params[:password]
    unless user.blank?
      session[:user_id] = user.id
      session[:user_name] = user.name
      session[:user_role] = user.role
      redirect_to root_path
    else
      redirect_to signin_path, :alert => '账号不存在或密码错误，请重试'
    end
  end
  
  def destroy
    reset_session
    redirect_to signin_path
  end
end

