# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
 
  belongs_to :user
  
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  
  default_scope -> { order(:created_at => :desc) }
  
   # Renvoie les micro-messages des utilisateurs suivis par un utilisateur donné.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  def self.from_users_followed_by(user)
    followed_ids = user.following.map(&:id).join(", ")
    where("user_id IN (#{followed_ids}) OR user_id = ?", user)
  end
  

  private

    # Renvoie une condition SQL pour les utilisateurs suivis par l'utilisateur donné.
    # Nous incluons aussi ses propres micro-messages.
    def self.followed_by(user)
      followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id",
            { :user_id => user })
    end
  
end
