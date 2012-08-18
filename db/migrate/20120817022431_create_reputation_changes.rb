class CreateReputationChanges < ActiveRecord::Migration
  def change
    create_table :reputation_changes do |t|
      t.integer :user_id
      t.integer :change
      t.integer :activity_id
      t.timestamps
    end
  end
end
