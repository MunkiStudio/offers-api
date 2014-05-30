class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.float :latitude
      t.float :longitude
      t.string :title
      t.text :description
      t.references :user, index: true

      t.timestamps
    end
  end
end
