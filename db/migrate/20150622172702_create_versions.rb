class CreateVersions < ActiveRecord::Migration
    
    def change
      create_table :versions do |t|
        t.string :nom, null:false
        t.string :chemin, null:false
        t.integer :datafile_id, null:false
        t.integer :user_id, null:false
        t.timestamps null: false
      end  
  end
  
end
