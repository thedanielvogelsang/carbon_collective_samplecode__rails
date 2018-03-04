class RemoveGroupsFromAdmin < ActiveRecord::Migration[5.1]
  def change
    remove_reference :admins, :group, foreign_key: true
  end
end
