class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.authenticate(params[:session][:login],
                           params[:session][:password])
    if user.nil?
      flash[:error] = "Combinaison Email/Mot de passe invalide."
      @titre = "Acceuil"
      redirect_to root_path
    else
      sign_in user
      redirect_back_or root_path
    end
    
  end
  
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  
  
end
