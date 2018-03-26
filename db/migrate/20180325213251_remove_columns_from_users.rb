class RemoveColumnsFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :workplace, :string
    remove_column :users, :school, :string
  end
end
