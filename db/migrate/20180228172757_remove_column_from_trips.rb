class RemoveColumnFromTrips < ActiveRecord::Migration[5.1]
  def change
    remove_column :trips, :timestamps, :string
  end
end
