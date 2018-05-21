class CarbonRanking < ApplicationRecord
  belongs_to :area, :polymorphic => true
end
