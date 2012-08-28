class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :target_id
      t.string :type
      t.integer :subscriber_id
      t.timestamps
    end
  end
end
