class Relationship < ActiveRecord::Base
  
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"
  has_many :following, :through => :relationships, :source => :followed
  
  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
  
end
