class CreateNamespaces < ActiveRecord::Migration[5.0]
  def change
    create_table :namespaces do |t|
      t.string :name
      t.integer :type, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
