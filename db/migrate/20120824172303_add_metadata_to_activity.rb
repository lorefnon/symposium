class AddMetadataToActivity < ActiveRecord::Migration
  def up
    add_column :activities, :metadata, :text
  end
  def down
    remove_column :actvities, :metadata
  end
end
