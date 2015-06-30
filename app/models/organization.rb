class Organization < ActiveRecord::Base
  
  has_many :contacts
    
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  
  
  validates :nom, :length   => { :maximum => 30 }
  
  validates :email, :format   => { :with => email_regex }
  
  
end
