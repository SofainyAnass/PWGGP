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
      Clientxmpp.connect(@current_user.login,params[:session][:password])
      on_message
    end
    redirect_to root_path
  end
  
  
  def destroy   
    Clientxmpp.disconnect
    sign_out   
    redirect_to root_path
  end
  
  private
  
  def on_message
    Clientxmpp.client.add_message_callback do |message|
      unless message.body.nil? && message.type != :error
            
            Message.create!(:source=> message.from, :destination => message.to,:content => message.body)

      end
    end

   end

  
 

  
  
  
  
  
end
