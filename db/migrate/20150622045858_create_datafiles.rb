class CreateDatafiles < ActiveRecord::Migration
  def change
    create_table :datafiles do |t|
      t.string :nom
      t.string :type_contenu
      t.string :extension    
      t.timestamps null: false
    end    
    add_index :datafiles, [:nom], :unique => true
  end
end
