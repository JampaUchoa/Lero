class AddOnlineToUser < ActiveRecord::Migration
  def change
    add_column :users, :online, :boolean, null: false, default: false
    add_index :users, :online
    add_column :users, :last_call, :datetime
  end
end
