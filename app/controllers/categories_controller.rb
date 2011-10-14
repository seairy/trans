# -*- encoding : utf-8 -*-
class CategoriesController < ApplicationController
  
  def index
    @categories = Category.arrange
  end
  
  def show
    @category = Category.find(params[:id])
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
    if @category.children.size > 0
      flash[:alert] = '该分类下存在子分类，请先删除所有子分类后重试！'
    elsif !@category.documents.blank?
      flash[:alert] = '该分类下存在文档，请先删除或移动所有文档后重试！'
    else
      @category.destroy
      flash[:notice] = '删除成功'
    end
    redirect_to(categories_path)
  end
end

