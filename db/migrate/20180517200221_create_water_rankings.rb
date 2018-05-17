class CreateWaterRankings < ActiveRecord::Migration[5.1]
  def change
    create_table :water_rankings do |t|
      t.references :area, polymorphic: true, index: true
      t.integer :rank
      t.boolean :arrow
      t.timestamps
    end
  end
end
