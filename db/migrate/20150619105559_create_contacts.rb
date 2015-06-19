class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :nom
      t.string :prenom
      t.string :email
      t.string :user_id

      t.timestamps null: false
   
    end
    add_index :contacts, :user_id 
  end
end
