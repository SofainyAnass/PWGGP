class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :nom, null:false, default: "nom"
      t.string :prenom, null:false, default:" prenom"
      t.string :email, null:false, default: "nom.prenom@example.com"
      t.integer :user_id

      t.timestamps null: false
   
    end
    add_index :contacts, :user_id  
    #index email unique
  end
end
