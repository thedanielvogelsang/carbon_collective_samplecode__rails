class AddColumnToTrips < ActiveRecord::Migration[5.1]
  def change
    add_column :trips, :timestamps, :text, array: true, default: []
  end
end
