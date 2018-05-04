class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :address_line1
      t.string :address_line2
      t.integer :zipcode

      t.timestamps
    end
  end
end
