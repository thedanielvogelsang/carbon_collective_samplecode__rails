class ElectricityRanking < ApplicationRecord
  belongs_to :area, :polymorphic => true
  
end
