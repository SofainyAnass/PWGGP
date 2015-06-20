class ContactsController < ApplicationController
  
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
      render 'edit'
    end
  end
  
private

  def contact_params
      params.require(:contact).permit(:nom, :prenom, :email)
  end
  
  
end
