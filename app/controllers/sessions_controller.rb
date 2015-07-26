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
      
      begin                   
                    
          @clientxmpp=Clientxmpp.new(user)
          
          @clientxmpp.connect(params[:session][:password])
          on_message
          on_presence
          on_iq
          
          sign_in user 
          #activity_check
          
          redirect_to "/" 
      
      rescue Exception => e  
          puts e.message  
          puts e.backtrace.inspect 
          flash[:error] = "Connexion au serveur de messagerie instantanée impossible."
          redirect_to :back
        
      end
     
      
      
    end
    
  end
  
  
  def destroy      
    sign_out    
  end
  
  private
  
  def on_message
    @clientxmpp.client.add_message_callback do |message|
      unless message.body.nil? && message.type != :error
            begin
              
              if(Clientxmpp.user_xmpp_name(@clientxmpp.user) == message.to)
                
                source = User.find_by_login(Clientxmpp.name_xmpp_user(message.from))
              
                dest =  User.find_by_login(Clientxmpp.name_xmpp_user(message.to))
                

                
                Message.create!(:id_source=> source.id, :id_destination => dest.id, :content => message.body)

                
              end
              
            rescue Exception => e  
                  puts e.message  
                  puts e.backtrace.inspect      
              
            end
            

      end
    end

  end
  
  def on_presence
    
    @clientxmpp.client.add_presence_callback do |presence|
      
        if(presence.type == :unavailable)
          
            Clientxmpp.clientxmpp(@current_user.login).set_discovery(Clientxmpp.name_xmpp_user(presence.from),false) 
          
        else
        
            if(presence.from ==(Clientxmpp.jid(@current_user)) && presence.to ==(Clientxmpp.jid(@current_user)))
    
                  @clientxmpp.presence = presence
            
            end
              
            Clientxmpp.clientxmpp(@current_user.login).set_discovery(Clientxmpp.name_xmpp_user(presence.from),true)  
        
        end

        
    end

  end
  
  def on_iq

    @clientxmpp.client.add_iq_callback do |iq|
      

       if(iq.first_element('ping'))
         
         if( @clientxmpp.current_user_last_activity > Clientxmpp.last_activity_tolerance )

                destroy
           
         end
     
       end
         
       if(iq.first_element('query'))
         
         if(iq.first_element('query').attributes['xmlns'] == "jabber:iq:last")
                   
                  if(iq.attributes['type'] == "get")
                      
                      @clientxmpp.send_activity(iq.from)
                      
                  elsif(iq.attributes['type'] == "result")
                    
                    @clientxmpp.set_activity(Clientxmpp.name_xmpp_user(iq.from),iq.first_element('query').attributes['seconds'].to_i)
     
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
  
  def activity_check
      
        Thread.new do        
          begin 
             
             while true
               
               if  @clientxmpp.current_user_last_activity > Clientxmpp.last_activity_tolerance        
                 
                  puts "ACTIVITY CHECK FAILED. DISCONNCECTED"
                          
                  destroy
                  break              
               end
               
             end             
             
          rescue Exception => e  
              puts e.message  
              puts e.backtrace.inspect 
              Clientxmpp.clientxmpp(user.login).set_discovery(user.login,false)                      
          end
           
        end
      
     
    end
  
  

  
 

  
  
  
  
  
end
