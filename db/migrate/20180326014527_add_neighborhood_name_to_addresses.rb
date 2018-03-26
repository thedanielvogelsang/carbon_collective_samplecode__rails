class AddNeighborhoodNameToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :neighborhood_name, :string
  end
end
