class CreateHouses < ActiveRecord::Migration[5.1]
  def change
    create_table :houses do |t|
      t.float :total_sq_ft
      t.integer :no_residents

      t.timestamps
    end
  end
end
