class Clientxmpp < ActiveRecord::Base
  include Jabber
  
  
  @@host = "127.0.0.1"
  @@domain = "destroyer"
  @@resource = "home"
  
  def client
    @@client
  end
  
  def client=(val)
    @@client = val
  end
  
  def self.connect(name,password)

    jid = JID.new(name)
    @@client = Client.new jid
    @@client.connect(@@host, 5222)
    @@client.auth "#{password}"
    @@client.send(Presence.new.set_type(:available))

  end
  
  def self.disconnect
    
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
  
  def self.client
    @@client
  end
  
  def self.client=(client)
    @@client=client
  end
  
  def self.user_xmpp_name(user)
    
    return "#{user.login}@#{@@domain}/#{@@resource}"
    
  end
  
  def self.name_xmpp_user(xmpp_name)
   
    name=xmpp_name.to_s
    name.remove!(/@#{@@domain}/)
    name.remove!("/")
    name.remove!(/#{@@resource}/)
    
     return name
    
  end
  
   

  
  
end