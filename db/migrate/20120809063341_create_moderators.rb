class CreateModerators < ActiveRecord::Migration
  def change
    create_table :moderators_tags do |t|
      t.integer :tag_id
      t.integer :moderator_id
    end
  end
end
