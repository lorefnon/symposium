class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :creator_id
      t.integer :target_id
      t.string :target_type
      t.boolean :is_flagged
      t.timestamps
    end
  end
end
