class AddColumnsToTrips < ActiveRecord::Migration[5.1]
  def change
    add_column :trips, :trip_type, :integer
    add_column :trips, :stop, :datetime
  end
end
