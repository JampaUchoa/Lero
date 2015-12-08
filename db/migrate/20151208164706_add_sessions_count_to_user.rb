class AddSessionsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :sessions_count, :integer, null: false, default: 0
  end
end
