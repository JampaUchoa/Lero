class AddPoliceToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :active, :boolean, null: false, default: true
    add_index :tenants, :active
    add_column :tenants, :banned, :boolean, null: false, default: false
    add_index :tenants, :banned
    add_column :tenants, :moderator, :boolean, null: false, default: false
    add_index :tenants, :moderator
  end
end
