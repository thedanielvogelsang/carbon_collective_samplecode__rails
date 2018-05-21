class CreateCarbonRankings < ActiveRecord::Migration[5.1]
  def change
    create_table :carbon_rankings do |t|
      t.references :area, polymorphic: true, index: true
      t.integer :rank
      t.boolean :arrow
      t.decimal :total_carbon_saved
      t.decimal :avg_daily_carbon_consumed_per_user
    end
  end
end
