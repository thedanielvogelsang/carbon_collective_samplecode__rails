class RemoveAdminFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_reference :users, :admin
  end
end
