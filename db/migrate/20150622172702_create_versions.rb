class CreateVersions < ActiveRecord::Migration
    
    def change
      create_table :versions do |t|
        t.string :nom
        t.string :chemin
        t.integer :datafile_id, null:false
        t.timestamps null: false
      end  
  end
  
end
