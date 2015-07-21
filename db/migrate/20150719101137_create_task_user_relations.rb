class CreateTaskUserRelations < ActiveRecord::Migration
  def change
    create_table :task_user_relations do |t|
      t.integer :task_id
      t.integer :user_id
      t.timestamps null: false
    end
    add_index :task_user_relations, :task_id
    add_index :task_user_relations, :user_id
    add_index :task_user_relations, [:task_id, :user_id], :unique => true
  end
end
