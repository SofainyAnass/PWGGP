# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  nom        :string           default("Mon organisation")
#  addresse   :string
#  email      :string           default("organisation@email.com")
#  telephone  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Organization < ActiveRecord::Base
  
  has_many :contacts
    
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  
  
  validates :nom, :length   => { :maximum => 30 }
  
  validates :email, :format   => { :with => email_regex }
  
  
end
