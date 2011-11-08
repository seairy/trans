# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  
  def index
    case user_role_in_session
    when User::ROLE_ADMIN
      @users = User.paginate :page => params[:page]
    when User::ROLE_CIO_MANAGER
      @users = User.editors.paginate :page => params[:page]
    when User::ROLE_HF_MANAGER
      @users = User.assignees.paginate :page => params[:page]
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to(@user, :notice => '创建成功')
    else
      render :action => "new"
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => '更新成功')
    else
      render :action => "edit"
    end
  end
  
  def update_password
    user = User.find user_id_in_session
    if user.hashed_password != Digest::MD5.hexdigest(params[:original_password])
      flash[:alert] = '原密码输入不正确，请重试'
    elsif params[:new_password] != params[:confirmed_password]
      flash[:alert] = '两次新密码输入不一致，请重试'
    elsif params[:new_password].blank?
      flash[:alert] = '新密码不能为空，请重试'
    elsif params[:new_password] !~ /^[a-zA-Z0-9_]{6,16}$/
      flash[:alert] = '新密码只能由大小写英文字母、数字和下划线组成，请重试'
    else
      user.update_attribute :hashed_password, Digest::MD5.hexdigest(params[:new_password])
      flash[:notice] = '密码修改成功'
    end
    redirect_to edit_password_users_path
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(users_url)
  end
end