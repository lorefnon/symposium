class CreateTagPriviledges < ActiveRecord::Migration
  def change
    create_table :tag_priviledges do |t|
      t.integer :user_id
      t.integer :tag_id
      t.integer :priviledge
      t.timestamps
    end
  end
end
