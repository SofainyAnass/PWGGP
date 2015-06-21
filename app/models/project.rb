# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  nom        :string
#  datedebut  :datetime
#  user_id    :integer
#  etat       :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Project < ActiveRecord::Base
  
  belongs_to :user
  
  has_many :project_user_relations, :foreign_key => :projet_id,
                                    :dependent => :destroy
                                    
  has_many :membres, :through => :project_user_relations, :source => :membre
  
  enum etat: [ "Nouveau", "En cours", "Terminé", "En arrêt"]
  
  validates :nom, :presence => true, :length => { :maximum => 50 }
  validates :datedebut, :presence => true
  
  
  def a_comme_membre?(user)
      project_user_relations.find_by_user_id(user)
  end
  
   def ajouter_membre!(user)
       project_user_relations.create!(:user_id => user.id)
   end
     
     
   def retirer_membre!(user)
      project_user_relations.find_by_user_id(user).destroy
   end
  
  
end
