class CreateConnexions < ActiveRecord::Migration
  def change
    create_table :connexions do |t|
      t.integer :user_id
      t.datetime :finish
      t.timestamps null: false
    end
    add_index :connexions, :user_id
  end
end
