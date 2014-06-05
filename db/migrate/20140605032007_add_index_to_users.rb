class AddIndexToUsers < ActiveRecord::Migration
  def change
  	add_index :users, :fb_token
  end
end
