class AddInviteMaxToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :invite_max, :integer
  end
end
