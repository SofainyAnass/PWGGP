class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :nom
      t.datetime :datedebut
      t.integer :user_id

      t.timestamps null: false
    end
     add_index :projects, :user_id 
  end
 
end
