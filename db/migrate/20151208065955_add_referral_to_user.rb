class AddReferralToUser < ActiveRecord::Migration
  def change
    add_column :users, :referral, :text
    add_index :users, :referral
  end
end
