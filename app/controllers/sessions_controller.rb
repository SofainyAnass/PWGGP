class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.authenticate(params[:session][:login],
                           params[:session][:password])
    if user.nil?
      flash[:error] = "Combinaison Email/Mot de passe invalide."
      @titre = "Acceuil"
    else
      sign_in user   
    end
    redirect_to root_path
  end
  
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  
  
end
