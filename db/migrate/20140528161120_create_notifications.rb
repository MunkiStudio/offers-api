class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.string :verb
      t.integer :subject_id, null: false
      t.string :subject_type, null: false
      t.integer :where_id
      t.string :where_type
      t.boolean :readed, default: false


      t.timestamps
    end
    add_index :notifications, :subject_id
    add_index :notifications, :subject_type
  end
end
