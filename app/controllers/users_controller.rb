class UsersController < ApplicationController
  protect_from_forgery except: :search

  def my_portfolio
    @tracked_stocks = current_user.stocks
    @user = current_user
  end

  def my_friends
    @friends = current_user.friendships
  end

  def search
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends)
      if @friends
        respond_to do |format|
          format.js { render partial: 'users/friend_result_js' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Couldn't find User"
          format.js { render partial: 'users/friend_result_js' }
        end
      end
    else
      respond_to do |format|
        p 'Please enter something'
        flash.now[:alert] = 'Please enter something'
        format.js { render partial: 'users/friend_result_js' }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end
end
