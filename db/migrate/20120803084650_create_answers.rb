class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body, :null => false
      t.integer :creator_id, :null => false
      t.integer :question_id, :null => false
      t.integer :upvote_count, :default => 0
      t.integer :downvote_count, :default => 0
      t.boolean :is_flagged, :default => false
      t.boolean :is_active, :default => true
      t.timestamps
    end
  end
end
