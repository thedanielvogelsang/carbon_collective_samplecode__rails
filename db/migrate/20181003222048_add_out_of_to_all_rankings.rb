class AddOutOfToAllRankings < ActiveRecord::Migration[5.1]
  def change
    add_column :carbon_rankings, :out_of, :integer
    add_column :electricity_rankings, :out_of, :integer
    add_column :water_rankings, :out_of, :integer
    add_column :gas_rankings, :out_of, :integer
  end
end
