class AddDescriptionHtmlToRepositories < ActiveRecord::Migration[5.0]
  def change
    add_column :repositories, :description_html, :text
  end
end
