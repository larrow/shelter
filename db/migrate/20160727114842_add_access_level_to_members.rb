class AddAccessLevelToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :access_level, :integer
  end
end
