class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.timestamps
    end

    create_table :notifications_users do |t|
      t.integer :notification_id
      t.integer :user_id
    end
  end
end
