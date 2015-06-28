# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  nom        :string           default("nom"), not null
#  prenom     :string           default(" prenom"), not null
#  email      :string           default("nom.prenom@example.com"), not null
#  fonction   :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Contact, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
