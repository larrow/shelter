class AddTagSize < ActiveRecord::Migration[5.0]
  def change
    add_column :image_tags, :size, :integer
  end
end
