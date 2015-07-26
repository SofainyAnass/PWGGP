# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  login              :string
#  encrypted_password :string
#  salt               :string
#  admin              :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class User < ActiveRecord::Base
  
  has_one :contact
  
  has_many :projects 
  
  has_many :project_user_relations, :foreign_key => :membre_id,
                                    :dependent => :destroy
  has_many :membre_de, :through => :project_user_relations, :source => :projet
  
  has_many :tasks
  
  has_many :task_user_relations, :foreign_key => :user_id,
                                    :dependent => :destroy
                                    
  has_many :charge_de, :through => :task_user_relations, :source => :task
  
  has_many :microposts, :dependent => :destroy
  
  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  has_many :datafiles, :dependent => :destroy
  
  has_many :messages, :foreign_key => "id_source",:dependent => :destroy
  
  has_many :reverse_messages, :foreign_key => "id_destination",
                                   :class_name => "Message",
                                   :dependent => :destroy
  
  has_many :sent_messages, :through => :messages, :source => :emetteur
  
  has_many :received_messages, :through => :messages, :source => :destinataire
  
  has_many :connexions, :dependent => :destroy
  
  
  attr_accessor :password
  
  
  
  validates :login,  :presence => true,
                     :length   => { :maximum => 50 },
                     :uniqueness => { :case_sensitive => false } 
                   
          
                    
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
                       
  before_save :encrypt_password
  
  
    def has_password?(password_soumis)
      encrypted_password == encrypt(password_soumis)
    end
    
    def self.authenticate(login, submitted_password)
      user = find_by_login(login)
      return nil  if user.nil?
      return user if user.has_password?(submitted_password)
    end
    
    def self.authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
    
    def feed
      Micropost.from_users_followed_by(self)
    end
    
    def following?(followed)
      relationships.find_by_followed_id(followed)
    end
  
    def follow!(followed)
      relationships.create!(:followed_id => followed.id)
    end
    
    def unfollow!(followed)
      relationships.find_by_followed_id(followed).destroy
    end
     
    def membre_de?(project)
       project_user_relations.find_by(:projet_id => project.id)
    end
     
    def ajouter_au_projet!(projet)
       project_user_relations.create!(:projet_id => projet.id)
    end
     
     
    def retirer_du_projet!(projet)
       project_user_relations.find_by(:projet_id => projet.id).destroy
    end
    
    def charge_de?(task)
       task_user_relations.find_by(:task_id => task.id)
    end
    
    def attribuer_tache!(task)
       task_user_relations.create!(:task_id => task.id)
    end
     
     
    def retirer_tache!(task)
       task_user_relations.find_by(:task_id => task.id).destroy
    end
    
    def nouveau_message!(destinataire,message)
      messages.create!(:id_destination => destinataire.id,:content => message)
    end
    
    def derniere_connexion
        connexions.first.finish.to_formatted_s(:normal) 
    end
    
    def contacts_utilisateur(user)
        users=User.all
        users.reject{ |u| u == User.find(user) }
        users
    end
    
    def en_ligne?(clientxmpp)
      
       clientxmpp.discovery(self.login)
      
    end
    
    def last_activity(clientxmpp,current_user)
    
        if current_user == self
          
            clientxmpp.current_user_last_activity
          
        else
          
            clientxmpp.activity(self)       
            
        end      
 
    end
    

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA512.hexdigest(string)
    end
                    
end
