class StocksController < ApplicationController
  protect_from_forgery except: %i[search refresh]

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

  def refresh
    stock = Stock.find(params[:stock])
    new_stock = Stock.new_lookup(stock.ticker)
    p new_stock
    stock.update(last_price: new_stock.last_price, name: new_stock.name)
    respond_to do |format|
      flash.now[:alert] = 'Refresh'
      format.js { render partial: 'users/refresh_js' }
    end

  end
end
