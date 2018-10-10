class CreateGlobalSnapshots < ActiveRecord::Migration[5.1]
  def change
    create_table :global_snapshots do |t|
      t.decimal :avg_user_electricity_consumption
      t.decimal :avg_user_water_consumption
      t.decimal :avg_user_gas_consumption
      t.decimal :avg_user_carbon_consumption
    end
  end
end
