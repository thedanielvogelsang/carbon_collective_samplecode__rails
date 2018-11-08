class CreateUserWaterBills < ActiveRecord::Migration[5.1]
  def change
    create_table :user_water_bills do |t|
      t.references :user, foreign_key: true
      t.references :water_bill, foreign_key: true

      t.timestamps
    end
  end
end
