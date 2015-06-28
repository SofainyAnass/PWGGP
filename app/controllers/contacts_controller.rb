class ContactsController < ApplicationController
  include SessionsHelper
  
  before_filter :authenticate
  
  def edit
    @titre = "Édition profil" 
    @contact = Contact.find(params[:id])  
  end
  
  def update
    @titre = "Édition profil"
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(contact_params)
      flash[:success] = "Profil actualisé."
      render 'edit'        
    else
      redirect_to 'edit' 
    end
  end
  
private

  def contact_params
      params.require(:contact).permit(:nom, :prenom, :email, :fonction)
  end
  
  
end
