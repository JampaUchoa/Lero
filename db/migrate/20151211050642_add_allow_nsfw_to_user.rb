class AddAllowNsfwToUser < ActiveRecord::Migration
  def change
    add_column :users, :allow_nsfw, :boolean, null: false, default: false
    add_index :users, :allow_nsfw
  end
end
