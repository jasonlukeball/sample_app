class StaticPagesController < ApplicationController

  # Empty actions automatically try to render a corresponding view

  def home
    if logged_in?
      @micropost = current_user.microposts.build if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end


end
