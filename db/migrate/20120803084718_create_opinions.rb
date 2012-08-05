class CreateOpinions < ActiveRecord::Migration
  def change
    create_table :opinions do |t|
      t.string :action, :null => false # upvote, downvote, flag
      t.integer :creator_id, :null => false
      t.integer :score_change, :null => false
      t.integer :target_id, :null => false
      t.integer :target_type, :null => false # question, answer
      t.boolean :to_flag, :null => false
      t.timestamps
    end
  end
end