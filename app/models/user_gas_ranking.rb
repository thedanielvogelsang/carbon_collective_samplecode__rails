class UserGasRanking < ApplicationRecord
  belongs_to :area, :polymorphic => true
  belongs_to :user
  validates_uniqueness_of :user_id, scope: [:area_id, :area_type]
end
