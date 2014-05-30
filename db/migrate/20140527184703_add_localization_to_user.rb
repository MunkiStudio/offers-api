class AddLocalizationToUser < ActiveRecord::Migration
  def change
  	add_column :users, :localization, :string
  end
end
