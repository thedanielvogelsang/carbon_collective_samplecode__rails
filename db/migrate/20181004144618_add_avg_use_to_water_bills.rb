class AddAvgUseToWaterBills < ActiveRecord::Migration[5.1]
  def change
    add_column :water_bills, :average_usage, :decimal
  end
end
