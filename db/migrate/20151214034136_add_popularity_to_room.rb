class AddPopularityToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :popularity, :float, null: false, default: 0
    add_index :rooms, :popularity
  end
end
