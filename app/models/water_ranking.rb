class WaterRanking < ApplicationRecord
  belongs_to :area, :polymorphic => true
  
end
