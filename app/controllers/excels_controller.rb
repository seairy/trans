# -*- encoding : utf-8 -*-
class ExcelsController < ApplicationController
  respond_to :xls, :html
  
  def export_translations
    if request.post?
      result = Translation.includes(:document).where('translations.id = ? OR documents.title LIKE ?', params[:keywords], "%#{params[:keywords]}%")
      result = result.where('translations.created_at >= ?', Date.new(params[:date_range][:'begin(1i)'].to_i,params[:date_range][:'begin(2i)'].to_i,params[:date_range][:'begin(3i)'].to_i).at_beginning_of_day) if Date.valid_civil?(params[:date_range][:'begin(1i)'].to_i,params[:date_range][:'begin(2i)'].to_i,params[:date_range][:'begin(3i)'].to_i)
      result = result.where('translations.created_at <= ?', Date.new(params[:date_range][:'end(1i)'].to_i,params[:date_range][:'end(2i)'].to_i,params[:date_range][:'end(3i)'].to_i)) if Date.valid_civil?(params[:date_range][:'end(1i)'].to_i,params[:date_range][:'end(2i)'].to_i,params[:date_range][:'end(3i)'].to_i)
      unless params[:category_id].blank?
        category = Category.find(params[:category_id])
        result = result.includes(:document).where(:'documents.category_id' => ([category.id] << category.descendants.all.collect{|c| c.id}).delete_if{|e| e.blank?})
      end
      unless params[:state].blank?
        result = result.where(state:params[:state])
      end
      result = result.includes(:language).where(:'languages.id' => params[:language_ids]) unless params[:language_ids].blank?
      @translations = result
      respond_with @translations do |format|
        format.xls
      end
    end
  end
end