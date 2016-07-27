class ChangeTypeToStringInNamespaces < ActiveRecord::Migration[5.0]
  def change
    change_column :namespaces, :type, :string
  end
end
