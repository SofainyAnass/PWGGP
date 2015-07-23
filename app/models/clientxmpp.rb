class Clientxmpp
  require 'xmpp4r/roster'
  require 'xmpp4r/last'
  require 'xmpp4r/discovery'
  require 'xmpp4r/iq'
  require 'xmpp4r/version/iq/version'
  require 'xmpp4r/query'
  require 'xmpp4r/rexmladdons'
  require 'xmpp4r/entity_time/iq'
  include Jabber
  
  
  @@host = "127.0.0.1"
  @@domain = "destroyer"
  @@resource = "home"
  @@clients = Hash.new
  @@discovery = Hash.new
  
  def client
    @client
  end

  def client=(val)
    @client = val
  end
  
  def roster    
     @roster
  end
  
  def roster=(val)
    @roster = val
  end
  
  def presence=(presence)   
    @presence  = presence  
  end
  
  def presence 
    @presence 
  end
  
  def set_activity(login,val)     
     @activity[login]=val
  end

  def activity(login)     
     @activity[login]
  end

  
  def get_activity   
     @activity
  end
   
  def activity_update(login)     
     @activity[login] = Time.current
  end 
  
   
  def discovery(login)     
     @@discovery[login] 
  end
  
  def set_discovery(login,val)    
     @@discovery[login]=val
  end
  
  def get_discovery   
     @@discovery
  end
  
   def self.stock(login,clientxmpp)
     @@clients[login]=clientxmpp    
   end
   
   def self.clientxmpp(login)     
     @@clients[login]    
   end

    def start_connetion_time
      @start_connetion_time
    end
    
    def start_connetion_time=(val)
      @start_connetion_time = val
    end
  

  def jid(user)

    JID.new(user.login,@@domain,@@resource)

  end
  
  def connect(user,password)
    
    Jabber.debug =true

    jid = jid(user)
    @client = Client.new jid
    @client.connect(@@host, 5222)
    @client.auth "#{password}"
    
    presence = Presence.new(nil,"Je suis disponible",1)
    presence.from=jid
    presence.to=@@domain
    presence.set_type(nil)
    
    @client.send(presence)
    
    @roster ||= Roster::Helper.new(@client) 
    
    @start_connetion_time = Time.current
    
    @activity = Hash.new
       
    @activity[user.login]=@start_connetion_time
    
    Clientxmpp.stock(user.login,self)
    
  end
 
  
  def disconnect   

    @@clients.delete(@client.jid.node)
    @roster = nil
    @client.close

  end
  
  def is_connected?
    @client.is_connected? 
  end
  
  def send_message(name, content)
    
    
    to = name
    subject = 'Message'
    body = content
    message = Message::new( to, body ).set_type(:chat).set_id('1').set_subject(subject)
    send message
    
    return message
    
  end
  

  def user_xmpp_name(user)
    
    name =  "#{user.login}@#{@@domain}/"
    
    if(@@resource!=nil)
      name+="#{@@resource}"    
    end
    
    return name
    
  end
  
  def name_xmpp_user(xmpp_name)
   
    name=xmpp_name.to_s
    name.remove!(/@#{@@domain}/)
    name.remove!("/")
    name.remove!(/#{@@resource}/)
    
     return name
    
  end
  
  
  def roster_update
    
     @roster ||= Roster::Helper.new(@client)
    
  end
  

  
  def get_activities(users)    
  
       users.each do |user|
 
         if(user.login != @client.jid.node)
         
           Thread.new do 
           
              begin 

                 r = LastActivity::Helper.new(@client).get_last_activity_from(jid(user))                  
                 Clientxmpp.clientxmpp(@client.jid.node).set_activity(user.login,r.seconds.to_i)
                 puts "GET ACTIVITIES"
                 puts r
                    
              rescue Exception => e  
                  puts e.message  
                  puts e.backtrace.inspect      
                  Clientxmpp.clientxmpp(@client.jid.node).set_activity(user.login,"-1")  
              end   
              
            end          
           
         end
         
        end 

  end
  
   def send_activity(user,destination)
    
    if destination == nil
      destination = @@domain
    end
    
    iq = Iq.new(:result,destination) 
    iq.from = jid(user)  
    query = LastActivity::IqQueryLastActivity.new      
    d = activity(user.login)-@start_connetion_time  
    query.set_second(d.to_i)
    iq.add(query)
    
    @client.send(iq)

    
  end
  
  def current_user_connection_time
    
    t = (activity(@client.jid.node)-start_connetion_time).to_i
    t
    
  end
  
  def current_user_last_activity
    
    t =  Time.current-activity(@client.jid.node)
    t
    
  end
  
  
  
  def self.second_from(iq)
   seconds = iq.attributes['seconds'] ? iq.attributes['seconds'].to_i : nil
   seconds
  end
  

 
    
  def disco(user)
    
      Thread.new do        
        begin 
           Discovery::Helper.new(@client).get_info_for(jid(user)) 
           Clientxmpp.clientxmpp(user.login).set_discovery(user.login,true)
        rescue Exception => e  
            puts e.message  
            puts e.backtrace.inspect   
           Clientxmpp.clientxmpp(user.login).set_discovery(user.login,false)   
        ensure   
          puts Clientxmpp.clientxmpp(user.login).get_discovery         
        end
         
      end
    
   
  end
  

  
  def show(show)
    
    send(Presence.new.set_show(show))
    
  end
  
 
  
  def pong(ping)
    
    iq = Iq.new(:result,ping.from)    
    iq.from = ping.to
    iq.id = ping.id   
    
    @client.send(iq)
    
    
     
  end
  
  def version(req)
    
    iq = Iq.new(:result,req.from) 
    iq.from = req.to  
    iq.id = req.id
    query = Version::IqQueryVersion.new("destroyereur","2","windows 7")  
    iq.add(query)
        
    @client.send(iq)

  end 
  
  def time(req)
    
    iq = Iq.new(:result,req.from) 
    iq.from = req.to  
    iq.id = req.id
    query = EntityTime::IqTime.new(Time.current)  
    iq.add(query)

    @client.send(iq)
    
  end
   
  
   
  
  
end