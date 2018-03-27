class AddColumnToAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :neighborhood, :string
  end
end
