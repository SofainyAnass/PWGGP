class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :nom
      t.date :datedebut
      t.date :datefin
      t.integer :etat, default: 0, null: false
      t.timestamps null: false
    end
  end
end
