class AddMessagesCountToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :chats_count, :integer, null: false, default: 0

  end
end
