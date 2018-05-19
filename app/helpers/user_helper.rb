module UserHelper

  def set_default_ranks
    UserElectricityRanking.create(user_id: self.id, rank: nil, arrow: nil)
    UserWaterRanking.create(user_id: self.id, rank: nil, arrow: nil)
    UserGasRanking.create(user_id: self.id, rank: nil, arrow: nil)
  end

end
