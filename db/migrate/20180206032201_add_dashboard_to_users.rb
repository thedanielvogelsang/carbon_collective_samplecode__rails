class AddDashboardToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :location, :string, array: true
    add_column :users, :workplace, :string
    add_column :users, :school, :string
  end
end
