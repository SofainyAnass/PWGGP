class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      
      t.string :nom
      t.string :addresse
      t.string :email
      t.string :telephone

      t.timestamps null: false
    end
  end
end
