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

require 'rails_helper'

RSpec.describe ProjectUserRelation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
