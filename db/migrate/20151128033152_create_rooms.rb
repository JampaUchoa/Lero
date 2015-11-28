class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.text :name
      t.text :description
      t.integer :privacy
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
