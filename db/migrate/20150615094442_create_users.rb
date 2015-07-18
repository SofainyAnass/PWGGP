class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string  :encrypted_password
      t.string  :salt
      t.boolean :admin
      
      t.timestamps null: false
    end
     add_index :users, :login
  end
end