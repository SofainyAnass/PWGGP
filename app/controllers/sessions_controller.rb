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
   
      @clientxmpp=Clientxmpp.new
      @clientxmpp.connect(@current_user,params[:session][:password]) 
     
      on_message
      on_presence
      on_iq
      on_stanza
      redirect_to "/"
      
    end
    
  end
  
  
  def destroy      
    sign_out    
  end
  
  private
  
  def on_message
    @clientxmpp.client.add_message_callback do |message|
      unless message.body.nil? && message.type != :error
            
            source = User.find_by_login(@clientxmpp.name_xmpp_user(message.from))
            
            dest =  User.find_by_login(@clientxmpp.name_xmpp_user(message.to))
            
            Message.create!(:id_source=> source.id, :id_destination => dest.id, :content => message.body)

      end
    end

  end
  
  def on_presence
    
    @clientxmpp.client.add_presence_callback do |presence|
      
        if(presence.type == :unavailable)
          
            Clientxmpp.clientxmpp(@current_user.login).set_discovery(@clientxmpp.name_xmpp_user(presence.from),false) 
          
        else
        
            if(presence.from ==(@clientxmpp.jid(@current_user)) && presence.to ==(@clientxmpp.jid(@current_user)))
    
                  @clientxmpp.presence = presence
            
            end
              
            Clientxmpp.clientxmpp(@current_user.login).set_discovery(@clientxmpp.name_xmpp_user(presence.from),true)  
        
        end

        
    end

  end
  
  def on_iq

    @clientxmpp.client.add_iq_callback do |iq|
      

       if(iq.first_element('ping'))
         
         @clientxmpp.pong(iq)
         
       end
         
       if(iq.first_element('query'))
         
         if(iq.first_element('query').attributes['xmlns'] == "jabber:iq:last")
                   
                  if(iq.attributes['type'] == "get")
                      
                      @clientxmpp.send_activity(@current_user,iq.from)
     
                  end 
         
          elsif(iq.first_element('query').attributes['xmlns'] == "jabber:iq:version")
                 
                  @clientxmpp.version(iq)
          end
        
        end
          
       if(iq.first_element('time'))

         @clientxmpp.time(iq)
       end
  

      
    end

  end
  
  def on_stanza
    @clientxmpp.client.add_stanza_callback do |stanza|

      
    end

  end
  
  

  
 

  
  
  
  
  
end
