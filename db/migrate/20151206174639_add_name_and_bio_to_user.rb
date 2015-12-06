class AddNameAndBioToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :text
    add_column :users, :bio, :text
  end
end
