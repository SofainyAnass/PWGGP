class PagesController < ApplicationController
  def acceuil
    @titre = "Acceuil"
    if signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end
  
  def inscription
    @titre = "Inscription" 
    @user = User.new
  end
  
  def administration
    @titre = "Configuration" 
  end

end
