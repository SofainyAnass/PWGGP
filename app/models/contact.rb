# == Schema Information
#
# Table name: contacts
#
#  id              :integer          not null, primary key
#  nom             :string           default("nom"), not null
#  prenom          :string           default(" prenom"), not null
#  email           :string           default("nom.prenom@example.com"), not null
#  fonction        :string
#  user_id         :integer
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Contact < ActiveRecord::Base
  
  belongs_to :user, :dependent => :destroy
  
  belongs_to :organization
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :nom, :presence => true,
                 :length   => { :maximum => 30 }
                   
  validates :prenom,  :presence     => true,
                     :length   => { :maximum => 30 }
  
  validates :email, :presence     => true,
                    #:uniqueness => { :case_sensitive => false }, 
                    :format   => { :with => email_regex }
  
  attr_accessor :nom_complet
  
  def recherche
    Contact.find(self.id).nom_complet
  end
  
  def nom_complet
    [self.prenom, self.nom].join(' ')
  end
  
  def nom_complet=(name)
    split = name.split(' ', 2)
    self.prenom = split.first
    self.nom = split.last
  end


  
  
end
