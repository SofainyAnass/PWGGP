class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                           params[:session][:password])
    if user.nil?
      flash.now[:error] = "Combinaison Email/Mot de passe invalide."
      @titre = "Acceuil"
      render '/pages/acceuil'
    else
      sign_in user
      redirect_back_or '/pages/acceuil'
    end
    
  end
  
  
  def destroy
    sign_out
    redirect_to "/pages/acceuil"
  end
  
  
  
end
