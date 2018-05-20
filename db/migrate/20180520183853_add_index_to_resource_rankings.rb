class AddIndexToResourceRankings < ActiveRecord::Migration[5.1]
  def change
    add_index :electricity_rankings, [:area_id, :area_type]
    add_index :water_rankings, [:area_id, :area_type]
    add_index :gas_rankings, [:area_id, :area_type]
  end
end
