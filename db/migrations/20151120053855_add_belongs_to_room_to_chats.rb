class AddBelongsToRoomToChats < ActiveRecord::Migration
  def change
    add_reference :chats, :room, index: true, foreign_key: true
    remove_reference :chats, :community

  end
end
