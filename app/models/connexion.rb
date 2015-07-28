# == Schema Information
#
# Table name: connexions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  finish     :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Connexion < ActiveRecord::Base
  
  
  belongs_to :user
  default_scope -> { order(:created_at => :desc) }
  
  validates :user_id, :presence => true
  
  
  def disconnect
    
    #update_attribute(:finish, Time.current)
    
  end
  
  
end
