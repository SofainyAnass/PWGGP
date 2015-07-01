class Message < ActiveRecord::Base
  
  
  belongs_to :emetteur, :class_name => "User"
  belongs_to :destinataire, :class_name => "User"
  
  validates :id_source, :presence => true
  validates :id_destination, :presence => true
  
  
  def self.messages_partages(user1,user2,heure)
    
    messages = Message.where(" ( ( id_source = (?) and id_destination = (?) ) and created_at > ? ) or ( ( id_source = (?) and id_destination = (?) ) and created_at > ? ) ", user1, user2, heure, user2, user1 , heure )
    
  end
  
  def user_source
    
    return User.find(id_source)
    
  end
  
end
