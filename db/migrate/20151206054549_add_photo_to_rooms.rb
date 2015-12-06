class AddPhotoToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :photo, :text
  end
end
