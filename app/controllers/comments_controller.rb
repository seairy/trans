# -*- encoding : utf-8 -*-
class CommentsController < ApplicationController
  before_filter :find_translation
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.translation_id = @translation.id
    @comment.user_id = user_id_in_session
    @comment.save
    redirect_to(@translation, :notice => '评论添加成功')
  end
  
  protected
  def find_translation
    @translation = Translation.find params[:translation_id]
  end
end