class AddNameIndexToAreas < ActiveRecord::Migration[5.1]
  def change
    add_index :countries, :name, :unique => true
    add_index :regions, :name, :unique => true
    add_index :cities, :name, :unique => true
    add_index :neighborhoods, :name, :unique => true
  end
end
