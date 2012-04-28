# -*- encoding : utf-8 -*-
class MailsController < ApplicationController
  skip_before_filter :authorize
  
  def create
    params[:addresses_with_names].each_line do |address_with_name|
      p address_with_name.chomp.split(%r{,\s*})
    end
    if !params[:addresses_with_names].blank? and !params[:title].blank? and !params[:mail_content].blank?
      params[:addresses_with_names].each_line do |address_with_name|
        address, name = String.new
        array = address_with_name.chomp.split %r{,\s*}
        if array.size > 1
          address, name = array[0].strip, array[1].strip
        else
          address = array[0].strip
        end
        Mailer.notification(address, name, params[:title], params[:mail_content]).deliver unless address.blank?
      end
      flash[:notice] = '发送成功'
    else
      flash[:alert] = '请输入完整信息'
    end
    redirect_to new_mail_path
  end
end

