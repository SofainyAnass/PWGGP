# == Schema Information
#
# Table name: messages
#
#  id             :integer          not null, primary key
#  id_source      :integer
#  id_destination :integer
#  content        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Message, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
