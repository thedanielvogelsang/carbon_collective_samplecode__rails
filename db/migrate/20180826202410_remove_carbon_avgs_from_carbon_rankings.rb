class RemoveCarbonAvgsFromCarbonRankings < ActiveRecord::Migration[5.1]
  def change
    remove_column :carbon_rankings, :total_carbon_saved, :decimal
    remove_column :carbon_rankings, :avg_daily_carbon_consumed_per_user, :decimal
  end
end
