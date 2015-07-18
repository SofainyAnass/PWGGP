class Connexion < ActiveRecord::Base
  
  
  belongs_to :user
  default_scope -> { order(:created_at => :desc) }
  
  validates :user_id, :presence => true
  
  
  def disconnect
    
    update_attribute(:finish, Time.current)
    
  end
  
  
end
