class AddDefaultPublicityToNamespaces < ActiveRecord::Migration[5.0]
  def change
    add_column :namespaces, :default_publicity, :boolean, default: true
  end
end
