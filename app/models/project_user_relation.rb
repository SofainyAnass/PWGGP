# == Schema Information
#
# Table name: project_user_relations
#
#  id         :integer          not null, primary key
#  membre_id  :integer
#  projet_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectUserRelation < ActiveRecord::Base
  
  belongs_to :membre, :class_name => "User"
  belongs_to :projet, :class_name => "Project"
  
  validates :membre_id, :presence => true
  validates :projet_id, :presence => true
  
end
