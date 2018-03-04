class AddAdminToGroups < ActiveRecord::Migration[5.1]
  def change
    add_reference :groups, :admin, foreign_key: true
  end
end
