class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      
      t.string :nom, default:"Mon organisation"
      t.string :addresse
      t.string :email, default:"organisation@email.com"
      t.string :telephone 

      t.timestamps null: false
    end
  end
end
