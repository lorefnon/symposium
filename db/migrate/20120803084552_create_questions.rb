class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title, :null => false
      t.text :description, :null => false
      t.integer :creator_id, :null => false
      t.integer :upvote_count, :default => 0
      t.integer :downvote_count, :default => 0
      t.boolean :is_closed, :default => false
      t.boolean :is_active, :default => true
      t.timestamps
    end
  end
end
