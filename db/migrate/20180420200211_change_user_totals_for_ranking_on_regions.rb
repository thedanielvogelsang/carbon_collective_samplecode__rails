class ChangeUserTotalsForRankingOnRegions < ActiveRecord::Migration[5.1]
  def change
    remove_column :countries, :avg_total_energy_saved_per_capita
    add_column :countries, :avg_total_energy_saved_per_user, :decimal
    add_column :countries, :avg_daily_energy_consumed_per_user, :decimal

    remove_column :regions, :avg_total_energy_saved_per_capita
    add_column :regions, :avg_total_energy_saved_per_user, :decimal
    add_column :regions, :avg_daily_energy_consumed_per_user, :decimal

    remove_column :cities, :avg_total_energy_saved_per_capita
    add_column :cities, :avg_total_energy_saved_per_user, :decimal
    add_column :cities, :avg_daily_energy_consumed_per_user, :decimal

    remove_column :neighborhoods, :avg_total_energy_saved_per_capita
    add_column :neighborhoods, :avg_total_energy_saved_per_user, :decimal
    add_column :neighborhoods, :avg_daily_energy_consumed_per_user, :decimal
  end
end
