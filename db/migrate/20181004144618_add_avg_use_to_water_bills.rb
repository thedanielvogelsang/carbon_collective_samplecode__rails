class AddAvgUseToWaterBills < ActiveRecord::Migration[5.1]
  def change
    add_column :water_bills, :average_daily_usage, :decimal
    add_column :water_bills, :force, :boolean, :default => false
  end
end
