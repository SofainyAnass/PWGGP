# En utilisant le symbole ':user', nous faisons que
# Factory Girl simule un modèle User.

FactoryGirl.define do  factory :task_user_relation do
    
  end
  factory :task do
    
  end
  factory :tach, :class => 'Tache' do
    
  end
  factory :connexion do
    
  end
  factory :conversation do
    
  end
  factory :message do
    
  end
  factory :organization_user_relation do
    
  end
  factory :oraganization do
    
  end
  factory :userdatadirectory do
    
  end
  factory :datadirectory do
    
  end
  factory :file_version_relation do
    
  end
  factory :version do
    nom "MyString"
chemin "MyString"
  end
  factory :data_file do
    
  end
  factory :project_user_relation do
    user_id 1
project_id 1
  end
  factory :relationproject do
    projet_id "MyString"
user_id "MyString"
  end
  factory :projet do
    nom "MyString"
datedebut "2015-06-19 19:14:08"
  end
  factory :contact do
    nom "MyString"
    prenom "MyString"
    email "MyString"
    association :user
  end
  factory :relationship do
      follower_id 1
      followed_id 1
  end

  
  factory :user do
    login                "Michael Hartl"
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
