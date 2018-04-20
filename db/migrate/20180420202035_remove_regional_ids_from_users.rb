class RemoveRegionalIdsFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :household, :float
    remove_column :users, :neighborhood, :float
    remove_column :users, :city, :float
    remove_column :users, :county, :float
    remove_column :users, :state_or_province, :float
    remove_column :users, :country, :float
  end
end
