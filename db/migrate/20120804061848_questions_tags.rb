class QuestionsTags < ActiveRecord::Migration
  def change
    create_table(:questions_tags) do |t|
      t.integer :question_id
      t.integer :tag_id
    end
  end
end
