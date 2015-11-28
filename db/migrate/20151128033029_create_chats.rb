class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|

      t.text :message
      t.belongs_to :user, index: true
      t.belongs_to :room, index: true
      t.datetime :deleted_at, index: true
      t.datetime :created_at, null: false, index: true
    end
  end
end
