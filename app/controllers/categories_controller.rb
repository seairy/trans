# -*- encoding : utf-8 -*-
class CategoriesController < ApplicationController
  
  def index
    @categories = Category.arrange
  end
  
  def new
    @category = Category.new
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to(categories_path, :notice => '创建成功')
    else
      render :action => "new"
    end
  end
  
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to(categories_path, :notice => '更新成功')
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to(categories_url)
  end
end

