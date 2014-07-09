class ChangeAgeForBirthdateOnUser < ActiveRecord::Migration
  def change
  	rename_column :users, :age, :birthdate
  end
end
