class AddDescriptionToRepositories < ActiveRecord::Migration[5.0]
  def change
    add_column :repositories, :description, :text
  end
end
