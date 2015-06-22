class CreateFileVersionRelations < ActiveRecord::Migration
  def change
    create_table :file_version_relations do |t|
      t.integer :fichier_id
      t.integer :version_id
      t.timestamps null: false
    end   
    add_index :file_version_relations, :fichier_id
    add_index :file_version_relations, :version_id
    add_index :file_version_relations, [:fichier_id, :version_id], :unique => true
  end
  
  
  
end
