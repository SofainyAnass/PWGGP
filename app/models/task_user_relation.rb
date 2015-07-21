# == Schema Information
#
# Table name: task_user_relations
#
#  id         :integer          not null, primary key
#  task_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TaskUserRelation < ActiveRecord::Base

  belongs_to :user, :class_name => "User"
  belongs_to :task, :class_name => "Task"
  
  validates :user_id, :presence => true
  validates :task_id, :presence => true

  
end
