class RenameMembersToGroupMembers < ActiveRecord::Migration[5.0]
  def change
    rename_table :members, :group_members
  end
end
