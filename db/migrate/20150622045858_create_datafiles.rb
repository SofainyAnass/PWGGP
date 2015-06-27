class CreateDatafiles < ActiveRecord::Migration
  def change
    create_table :datafiles do |t|
      t.string :nom, null:false
      t.string :description
      t.string :type_contenu
      t.integer :version, null:false, default:1
      t.string :chemin  
      t.string :fichier_id, default:0
      t.string :user_id, null:false
      t.timestamps null: false
    end    
  end
end
