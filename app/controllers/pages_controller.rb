class PagesController < ApplicationController
  def acceuil
    @titre = "Acceuil"
    if signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end
  
  def show
    
  end
end
