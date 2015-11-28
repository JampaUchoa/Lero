class AddConfirmTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :confirm_token, :text
    add_index :users, :confirm_token
  end
end
