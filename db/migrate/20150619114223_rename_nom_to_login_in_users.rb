class RenameNomToLoginInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :nom, :login
  end
end
