class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :creator_id
      t.text :description
      t.timestamps
    end
  end
end
