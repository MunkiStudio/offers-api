class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.references :offer, index: true
      t.references :group, index: true

      t.timestamps
    end
  end
end
