class Clientxmpp < ActiveRecord::Base
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
  
  def self.client
    @@client
  end
  
  def self.client=(client)
    @@client=client
  end
  
    def self.roster    
     @@roster
  end
  
  def self.roster=(val)
    @@roster = val
  end
  
  def self.presence=(presence)   
    @@presence = presence  
  end
  
  def self.presence 
    @@presence 
  end
  
  
  
  def self.jid(user)

    return JID.new(user.login,@@domain,@@resource)

  end
  
  def self.connect(user,password)
    
    debug = true
    
    jid = jid(user)
    @@client = Client.new jid
    @@client.connect(@@host, 5222)
    @@client.auth "#{password}"
    
    presence = Presence.new(nil,"Je suis disponible",1)
    presence.from=jid
    presence.to=@@domain
    presence.set_type(nil)
    
    @@client.send(presence)
    
    @@roster ||= Roster::Helper.new(@@client)

  end
  
  def self.disconnect
    
    @@roster = nil
    @@client.close

  end
  
  def self.send_message(name, content)
    
    
    to = name
    subject = 'Message'
    body = content
    message = Message::new( to, body ).set_type(:chat).set_id('1').set_subject(subject)
    @@client.send message
    
    return message
    
  end
  

  def self.user_xmpp_name(user)
    
    name =  "#{user.login}@#{@@domain}/"
    
    if(@@resource!=nil)
      name+="#{@@resource}"    
    end
    
    return name
    
  end
  
  def self.name_xmpp_user(xmpp_name)
   
    name=xmpp_name.to_s
    name.remove!(/@#{@@domain}/)
    name.remove!("/")
    name.remove!(/#{@@resource}/)
    
     return name
    
  end
  
  def self.roster_items
      
    return @@roster.items
       
  end
  
  def self.is_connected?

    return @@client.is_connected?
    
  end
  
  def self.roster_update
    
     @@roster ||= Roster::Helper.new(@@client)
    
  end
  
  def self.last_activity(user)
    
    LastActivity::Helper.new(@@client).get_last_activity_from(jid(user))
 
  end
  
  def self.disco(user)
    
    return Discovery::Helper.new(@@client).get_info_for(jid(user)) 
    
  end
  
  def self.show(show)
    
    @@client.send(Presence.new.set_show(show))
    
  end
  
  def self.answer(req)
    
    iq = Iq.new(:result,req.from)
    iq.from = req.to     
    query = LastActivity::IqQueryLastActivity.new
    query.set_second(100)
    iq.add(query)
    iq
    
  end
  
  def self.send_activity(user,from,duration)
    
    iq = Iq.new(:result,from) 
    iq.from = jid(user)  
    query = LastActivity::IqQueryLastActivity.new
    query.set_second(duration)
    iq.add(query)
    puts iq
    
    @@client.send(iq)
    
    puts iq
    
  end
  
  def self.pong(ping)
    
    iq = Iq.new(:result,ping.from)    
    iq.from = ping.to
    iq.id = ping.id   
    
    puts iq
    
    @@client.send(iq)
    
    
     
  end
  
  def self.version(req)
    
    iq = Iq.new(:result,req.from) 
    iq.from = req.to  
    iq.id = req.id
    query = Version::IqQueryVersion.new("destroyereur","2","windows 7")  
    iq.add(query)
    
    puts iq
    
    @@client.send(iq)

  end 
  
  def self.time(req)
    
    iq = Iq.new(:result,req.from) 
    iq.from = req.to  
    iq.id = req.id
    query = EntityTime::IqTime.new(Time.current)  
    iq.add(query)
    
    puts iq
    
    @@client.send(iq)
    

     
  end
  
  
   

  
  
end