# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  nom        :string
#  prenom     :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

require 'rails_helper'

RSpec.describe Contact, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
