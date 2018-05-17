class CreateElectricityRankings < ActiveRecord::Migration[5.1]
  def change
    create_table :electricity_rankings do |t|
      t.references :area, polymorphic: true, index: true
      t.integer :rank
      t.boolean :arrow
    end
  end
end
