class AddIndexToNameInNamespacesAndRepositories < ActiveRecord::Migration[5.0]
  def change
    add_index :namespaces, :name
    add_index :repositories, :name
  end
end
