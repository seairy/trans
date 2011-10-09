# -*- encoding : utf-8 -*-
class NoticesController < ApplicationController
  
  def index
    @notices = Notice.where(user_id:user_id_in_session)
  end
end