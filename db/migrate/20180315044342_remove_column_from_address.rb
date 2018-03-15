class RemoveColumnFromAddress < ActiveRecord::Migration[5.1]
  def change
    remove_column :addresses, :zipcode, :integer
  end
end
