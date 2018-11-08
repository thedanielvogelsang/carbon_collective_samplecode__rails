class CreateUserElectricBills < ActiveRecord::Migration[5.1]
  def change
    create_table :user_electric_bills do |t|
      t.references :user, foreign_key: true
      t.references :electric_bill, foreign_key: true

      t.timestamps
    end
  end
end
