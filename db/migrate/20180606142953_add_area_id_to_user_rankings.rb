class AddAreaIdToUserRankings < ActiveRecord::Migration[5.1]
  def change
    add_reference :user_gas_rankings, :area, polymorphic: true, index: true
    add_index :user_gas_rankings, [:area_id, :area_type]
    add_reference :user_electricity_rankings, :area, polymorphic: true, index: true
    add_index :user_electricity_rankings, [:area_id, :area_type]
    add_reference :user_water_rankings, :area, polymorphic: true, index: true
    add_index :user_water_rankings, [:area_id, :area_type]
    add_reference :user_carbon_rankings, :area, polymorphic: true, index: true
    add_index :user_carbon_rankings, [:area_id, :area_type]
  end
end
