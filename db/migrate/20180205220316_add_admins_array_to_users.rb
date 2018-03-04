class AddAdminsArrayToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admins, :string, array: true
  end
end
