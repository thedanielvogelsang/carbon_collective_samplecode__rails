class AddAptToggleToHouses < ActiveRecord::Migration[5.1]
  def change
    add_column :houses, :apartment, :boolean, :default => false
  end
end
