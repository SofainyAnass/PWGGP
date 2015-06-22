class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :nom, null:false
      t.string :prenom, null:false
      t.string :email, null:false
      t.integer :user_id

      t.timestamps null: false
   
    end
    add_index :contacts, :user_id 
  end
end
