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
      on_iq
      on_stanza
      redirect_to "/acceuil"
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
    Clientxmpp.client.add_presence_callback do |presence|
      
        puts "Presence : #{presence.from}"
        
        if(presence.from ==(Clientxmpp.jid(@current_user)) && presence.to ==(Clientxmpp.jid(@current_user)))

              Clientxmpp.presence = presence
        end
        
        

    end

  end
  
  def on_iq
    Clientxmpp.client.add_iq_callback do |iq|
        
       if(!iq.first_element("ping").to_s.blank?)

         Clientxmpp.pong(iq)
       end
       
       if(!iq.first_element("query").to_s.blank?)
          
          if(iq.first_element("query").to_s.include?"jabber:iq:last")
               
                Clientxmpp.send_activity(@current_user,iq.from,100)
                
          elsif(iq.first_element("query").to_s.include?"jabber:iq:version")
               
                Clientxmpp.version(iq)
          end
          
       end
       
       if(!iq.first_element("time").to_s.blank?)

         Clientxmpp.time(iq)
       end
  

      
    end

  end
  
  def on_stanza
    Clientxmpp.client.add_stanza_callback do |stanza|

       puts "Stanza : #{stanza}"
      
    end

  end
  
  

  
 

  
  
  
  
  
end
