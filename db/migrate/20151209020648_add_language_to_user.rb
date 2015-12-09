class AddLanguageToUser < ActiveRecord::Migration
  def change
    add_column :users, :language, :text
    add_index :users, :language
  end
end
