class AddDeletedAtToRepositories < ActiveRecord::Migration[5.0]
  def change
    add_column :repositories, :deleted_at, :datetime
    add_index :repositories, :deleted_at
  end
end
