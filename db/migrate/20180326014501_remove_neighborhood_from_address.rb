class RemoveNeighborhoodFromAddress < ActiveRecord::Migration[5.1]
  def change
    remove_column :addresses, :neighborhood, :string
  end
end
