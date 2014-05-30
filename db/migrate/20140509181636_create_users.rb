class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.integer :age
      t.string :password
      t.string :email
      t.text   :password_digest
      t.timestamps
    end
    add_index :users, ["id"], name: "index_users_on_id", unique: true
    add_index :users,["email"], name: "index_users_on_email", unique: true
    add_index :users, ["username"], name: "index_users_on_username", unique: true
  end
end
