class AddCountyToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :county, :string
  end
end
