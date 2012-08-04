class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :target_id
      t.string :target_type
      t.integer :subscriber_id
      t.timestamps
    end
  end
end
