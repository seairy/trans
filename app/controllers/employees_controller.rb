# -*- encoding : utf-8 -*-
class EmployeesController < ApplicationController
  
  def index
    @employees = Employee.paginate :page => params[:page]
  end
  
  def show
    @employee = Employee.find(params[:id])
  end
  
  def new
    @employee = Employee.new
  end
  
  def edit
    @employee = Employee.find(params[:id])
  end
  
  def create
    @employee = Employee.new(params[:employee])
    if @employee.save
      redirect_to(@employee, :notice => '创建成功')
    else
      render :action => "new"
    end
  end
  
  def update
    @employee = Employee.find(params[:id])
    if @employee.update_attributes(params[:employee])
      redirect_to(@employee, :notice => '更新成功')
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    redirect_to(employees_url)
  end
end