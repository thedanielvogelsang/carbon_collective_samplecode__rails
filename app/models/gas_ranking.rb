class GasRanking < ApplicationRecord
  belongs_to :area, :polymorphic => true
  
end
