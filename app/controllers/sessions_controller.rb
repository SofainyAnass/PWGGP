class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.authenticate(params[:session][:login],
                           params[:session][:password])
    if user.nil?
      flash[:error] = "Combinaison Email/Mot de passe invalide."
      @titre = "Acceuil"
      redirect_to :back
    else
      sign_in user                
      Clientxmpp.connect(@current_user,params[:session][:password])
      on_message
      on_presence
      redirect_to "/accueil"
    end
    
  end
  
  
  def destroy      
    sign_out    
  end
  
  private
  
  def on_message
    Clientxmpp.client.add_message_callback do |message|
      unless message.body.nil? && message.type != :error
            
            source = User.find_by_login(Clientxmpp.name_xmpp_user(message.from))
            
            dest =  User.find_by_login(Clientxmpp.name_xmpp_user(message.to))
            
            Message.create!(:id_source=> source.id, :id_destination => dest.id, :content => message.body)

      end
    end

  end
  
  def on_presence
    Clientxmpp.client.add_message_callback do |message|
      unless message.body.nil? && message.type != :error
            
            Clientxmpp.roster_update

      end
    end

  end

  
 

  
  
  
  
  
end
