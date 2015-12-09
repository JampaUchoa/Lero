class AddMediaTypeAndContentToChat < ActiveRecord::Migration
  def change
    add_column :chats, :media_type, :integer
    add_index :chats, :media_type
    add_column :chats, :image_content, :text
    add_column :chats, :video_content, :text
  end
end
