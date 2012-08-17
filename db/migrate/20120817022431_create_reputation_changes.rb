class CreateReputationChanges < ActiveRecord::Migration
  def change
    create_table :reputation_changes do |t|

      t.timestamps
    end
  end
end
