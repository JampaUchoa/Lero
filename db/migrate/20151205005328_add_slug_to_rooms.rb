class AddSlugToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :slug, :text
    add_index :rooms, :slug, unique: true
  end
end
