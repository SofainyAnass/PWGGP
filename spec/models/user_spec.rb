# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  login              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  encrypted_password :string
#  salt               :string
#  admin              :boolean
#

require 'rails_helper'

describe User, "Attributs" do

  before(:each) do
    @user = FactoryGirl.build(:user)
  end
    
  it{ @user.should have_attribute(:nom) }
  it{ @user.should have_attribute(:email) }
  
end


 
describe User, "Validation"  do
  
  before(:each) do
    @user = FactoryGirl.build(:user)
  end

  it{ @user.should be_valid }
 
  
end


