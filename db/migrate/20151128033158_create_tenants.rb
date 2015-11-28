class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.belongs_to :user, index: true
      t.belongs_to :room, index: true
      t.integer :last_chat, index: true
      t.timestamps null: false
    end
    add_index :tenants, [:user_id, :room_id], unique: true
  end
end
