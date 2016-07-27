class ChangeTypeToStringInNamespaces < ActiveRecord::Migration[5.0]
  def change
    remove_column :namespaces, :type, :integer
    add_column :namespaces, :type, :string
  end
end
