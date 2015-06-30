class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :source
      t.string :destination
      t.string :content
      t.timestamps null: false
    end
  end
end
