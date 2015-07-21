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

require 'rails_helper'

RSpec.describe Task, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
