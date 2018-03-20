class AddTotalsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :household, :float
    add_column :users, :neighborhood, :float
    add_column :users, :city, :float
    add_column :users, :county, :float
    add_column :users, :state_or_province, :float
    add_column :users, :country, :float
  end
end
