class RestructureAddress < ActiveRecord::Migration[5.1]
  def change
    remove_column :addresses, :county, :string
    add_reference :addresses, :city, foreign_key: true
  end
end
