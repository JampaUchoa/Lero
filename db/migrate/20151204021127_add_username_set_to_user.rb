class AddUsernameSetToUser < ActiveRecord::Migration
  def change
    add_column :users, :username_set, :boolean, null: false, default: false
  end
end
