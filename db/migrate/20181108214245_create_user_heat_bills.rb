class CreateUserHeatBills < ActiveRecord::Migration[5.1]
  def change
    create_table :user_heat_bills do |t|
      t.references :user, foreign_key: true
      t.references :heat_bill, foreign_key: true

      t.timestamps
    end
  end
end
