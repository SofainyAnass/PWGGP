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

require 'rails_helper'

RSpec.describe TaskUserRelation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
