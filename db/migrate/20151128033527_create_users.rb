class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.text :username
      t.text :email
      t.integer :admin
      t.text :password_digest
      t.text :remember_digest
      t.timestamps null: false
    end
  end
end
