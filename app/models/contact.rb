# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  nom        :string
#  prenom     :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contact < ActiveRecord::Base
  
  belongs_to :user, :dependent => :destroy
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :nom, :length   => { :maximum => 30 }
                   
  validates :prenom, :length   => { :maximum => 30 }
  
  validates :email, :uniqueness => { :case_sensitive => false }  #, :format   => { :with => email_regex }
  
  
end
