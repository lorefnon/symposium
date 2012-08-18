class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :priority
      t.integer :activity_id
      t.boolean :is_read
      t.timestamps
    end
  end
end
