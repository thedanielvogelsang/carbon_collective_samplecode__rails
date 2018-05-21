class AddIndexToCo2Rankings < ActiveRecord::Migration[5.1]
  def change
    add_index :carbon_rankings, [:area_id, :area_type]
  end
end
