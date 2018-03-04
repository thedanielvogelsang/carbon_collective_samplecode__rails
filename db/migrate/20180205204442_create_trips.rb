class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.string :timestamps
      t.string :trip_name
      t.string :mode_of_transport

      t.timestamps
    end
  end
end
