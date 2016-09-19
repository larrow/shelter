class RemoveSourceTypeInMembers < ActiveRecord::Migration[5.0]
  def change
    remove_column :group_members, :source_type, :string
  end
end
