class PagesController < ApplicationController
  
  before_filter :authenticate, :only => [:administration]
  
  def acceuil
    @titre = "Acceuil"
    if signed_in?
      @micropost = Micropost.new
      @microposts = current_user.feed.paginate(:page => params[:page])

    end
    
  end
  
  def inscription
    @titre = "Inscription" 
    @user = User.new
  end
  
  def administration
    @titre = "Configuration" 
  end
  
  def projet
    redirect_to membre_de_user_path(current_user)    
  end
  
  def ged
    redirect_to fichiers_utilisateur_user_path(current_user)  
  end
  
  def calendrier
    @titre = "Calendrier"
  end

end
