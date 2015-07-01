class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :id_source
      t.integer :id_destination
      t.string :content
      t.timestamps null: false
    end
  end
end
