class ContactsController < ApplicationController
  include SessionsHelper
  
  autocomplete :contact, :nom, :display_value => :recherche
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
    end
      redirect_to :back
    
  end
  
  def show    
    @contact = Contact.find(params[:id])
    @titre = "Profil de #{@contact.nom_complet}"
  end
  
  
private

  def contact_params
      params.require(:contact).permit(:nom, :prenom, :email, :fonction)
  end
  
  
end
