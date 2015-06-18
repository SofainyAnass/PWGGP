# En utilisant le symbole ':user', nous faisons que
# Factory Girl simule un modèle User.

FactoryGirl.define do  factory :relationship do
    follower_id 1
followed_id 1
  end

  
  factory :user do
  nom                 "Michael Hartl"
  email                 "mhartl@example.com"
  password              "foobar"
  password_confirmation "foobar"
  end
  
  factory :micropost do 
  content "Foo bar"
  association :user
  end
  
  sequence :email do |n|
  "person-#{n}@example.com"
  end
  
end
