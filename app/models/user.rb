# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  login              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  encrypted_password :string
#  salt               :string
#  admin              :boolean
#

class User < ActiveRecord::Base
  
  has_one :contact
  
  has_many :projects
  
  has_many :microposts, :dependent => :destroy
  
  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
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
