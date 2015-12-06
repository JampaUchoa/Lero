class AddCounterToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :tenants_count, :integer, null: false, default: 0
  end
end
