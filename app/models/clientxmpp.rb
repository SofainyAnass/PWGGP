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
  
  def self.connect(login,password)

    jid = JID.new("#{login}@#{@@domain}/#{@@resource}")
    @@client = Client.new jid
    @@client.connect(@@host, 5222)
    @@client.auth "#{password}"
    @@client.send(Presence.new.set_type(:available))

  end
  
  def self.disconnect
    
    @@client.close

  end
  
  def self.send_message(login, content)
    
    
    to = "#{login}@#{@@domain}/#{@@resource}"
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
  
  def self.to_xmpp_address(login)
      
    return "#{login}@#{@@domain}/#{@@resource}"
    
  end
  
   

  
  
end