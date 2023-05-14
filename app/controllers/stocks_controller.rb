class StocksController < ApplicationController
  protect_from_forgery except: :search

  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock
        respond_to do |format|
          format.js { render partial: 'users/result_js' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = 'Invalid symbol!'
          format.js { render partial: 'users/result_js' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = 'Please enter a symbol to search'
        format.js { render partial: 'users/result_js' }
      end
    end
  end
end
