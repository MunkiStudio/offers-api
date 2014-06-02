class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :sender, index: true
      t.references :recipient, index: true
      # t.integer :target_id
      # t.string :target_type
      # t.integer :object_id
      # t.string :object_type
      t.references :target, polymorphic: true
      t.references :object, polymorphic: true
      t.string :verb
      t.boolean :readed, default:false
      t.timestamps
    end

  end
end
