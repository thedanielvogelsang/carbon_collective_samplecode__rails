class CreateUserRankings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_electricity_rankings do |t|
      t.integer :rank
      t.boolean :arrow
      t.references :user, foreign_key: true
      t.timestamps
    end
    create_table :user_water_rankings do |t|
      t.integer :rank
      t.boolean :arrow
      t.references :user, foreign_key: true
      t.timestamps
    end
    create_table :user_gas_rankings do |t|
      t.integer :rank
      t.boolean :arrow
      t.references :user, foreign_key: true
      t.timestamps
    end
    create_table :user_carbon_rankings do |t|
      t.integer :rank
      t.boolean :arrow
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
