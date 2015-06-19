class Project < ActiveRecord::Base
  
  belongs_to :user
  
  validates :nom, :presence => true, :length => { :maximum => 50 }
  validates :datedebut, :presence => true
  
  
end
