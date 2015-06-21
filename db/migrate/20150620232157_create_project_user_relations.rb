class CreateProjectUserRelations < ActiveRecord::Migration
  def change
    create_table :project_user_relations do |t|
      t.integer :membre_id
      t.integer :projet_id

      t.timestamps null: false
    end
    add_index :project_user_relations, :membre_id
    add_index :project_user_relations, :projet_id
    add_index :project_user_relations, [:membre_id, :projet_id], :unique => true
  end
end
