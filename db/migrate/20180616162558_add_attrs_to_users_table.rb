class AddAttrsToUsersTable < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_login, :datetime
    add_column :users, :total_logins, :integer
    add_column :users, :avg_time_btw_logins, :float
  end
end
