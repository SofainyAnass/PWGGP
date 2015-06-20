class Project < ActiveRecord::Base
  
  belongs_to :user
  
  enum etat: [ "Nouveau", "En cours", "Terminé", "En arrêt"]
  
  validates :nom, :presence => true, :length => { :maximum => 50 }
  validates :datedebut, :presence => true
  
  
end
