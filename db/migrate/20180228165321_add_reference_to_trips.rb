class AddReferenceToTrips < ActiveRecord::Migration[5.1]
  def change
    add_reference :trips, :day, foreign_key: true
  end
end
