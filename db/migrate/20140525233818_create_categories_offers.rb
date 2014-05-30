class CreateCategoriesOffers < ActiveRecord::Migration
  def change
    create_table :categories_offers do |t|
    	t.references :category, null:false
      	t.references :offer, null:false
    end
  end
end
