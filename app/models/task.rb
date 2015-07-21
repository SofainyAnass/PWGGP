# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  nom        :string
#  datedebut  :date
#  datefin    :date
#  etat       :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Task < ActiveRecord::Base
  
  belongs_to :user
  
  has_many :task_user_relations, :foreign_key => :task_id,
                                    :dependent => :destroy
                                    
  has_many :charges, :through => :task_user_relations, :source => :user
  
  enum etat: [ "Nouveau", "En cours", "Terminé", "En arrêt"]
  
  validates :nom, :presence => true, :length => { :maximum => 50 }
  validates :datedebut, :presence => true
  validates :datefin, :presence => true
  
end
