class AddNsfwToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :nsfw, :boolean, null: false, default: false
    add_index :rooms, :nsfw
  end
end
