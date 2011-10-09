# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  
  def index
    case user_role_in_session
    when User::ROLE_ADMIN then render 'admin'
    when User::ROLE_CIO_MANAGER then render 'cio_manager'
    when User::ROLE_EDITOR then render 'editor'
    when User::ROLE_HF_MANAGER then render 'hf_manager'
    when User::ROLE_ASSIGNEE then render 'assignee'
    end
  end
end

