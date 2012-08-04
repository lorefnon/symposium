class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body, :null => false
      t.integer :creator_id, :null => false
      t.integer :question_id, :null => false
      t.integer :upvotes, :null => false
      t.integer :downvotes, :null => false
      t.boolean :is_flagged, :null => false
      t.timestamps
    end
  end
end
