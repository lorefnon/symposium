class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title, :null => false
      t.text :description, :null => false
      t.integer :creator_id, :null => false
      # t.integer :upvotes
      # t.integer :downvotes
      t.boolean :is_closed, :null => false
      t.timestamps
    end
  end
end
