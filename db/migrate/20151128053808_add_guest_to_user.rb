class AddGuestToUser < ActiveRecord::Migration
  def change
    add_column :users, :guest, :boolean, null: false, default: true
    add_index :users, :guest
  end
end
