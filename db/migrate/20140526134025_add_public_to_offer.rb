class AddPublicToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :access_public, :boolean, :default => true
  end
end
