class AddIsPublicToRepositories < ActiveRecord::Migration[5.0]
  def change
    add_column :repositories, :is_public, :boolean
  end
end
