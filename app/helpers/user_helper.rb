module UserHelper

    def account_length_time
      DateTime.now - self.created_at.to_datetime + 1
    end

    def household
      self.houses.first if !self.houses.empty?
    end

    def address
      self.houses.empty? ? nil : household.address.address
    end

    def neighborhood
      (!self.houses.empty? && self.houses.first.address.neighborhood) ? household.address.neighborhood : nil
    end

    def city
      self.houses.empty? ? nil : household.address.city
    end

    def county
      self.houses.empty? ? nil : household.address.county
    end

    def region
      self.houses.empty? ? nil : household.address.region
    end

    def country
      self.houses.empty? ? nil : household.address.country
    end

  def set_default_ranks
    if self.user_electricity_rankings.empty? && self.user_water_rankings.empty?
    #Country
    UserElectricityRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.country.id, area_type: "Country")
    UserWaterRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.country.id, area_type: "Country")
    UserGasRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.country.id, area_type: "Country")
    UserCarbonRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.country.id, area_type: "Country")
    #Region
    UserElectricityRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.region.id, area_type: "Region")
    UserWaterRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.region.id, area_type: "Region")
    UserGasRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.region.id, area_type: "Region")
    UserCarbonRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.region.id, area_type: "Region")

    #County
    UserElectricityRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.county.id, area_type: "County")
    UserWaterRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.county.id, area_type: "County")
    UserGasRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.county.id, area_type: "County")
    UserCarbonRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.county.id, area_type: "County")

    #City
    UserElectricityRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.city.id, area_type: "City")
    UserWaterRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.city.id, area_type: "City")
    UserGasRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.city.id, area_type: "City")
    UserCarbonRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.city.id, area_type: "City")

    #Neighborhood
    UserElectricityRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.neighborhood.id, area_type: "Neighborhood")
    UserWaterRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.neighborhood.id, area_type: "Neighborhood")
    UserGasRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.neighborhood.id, area_type: "Neighborhood")
    UserCarbonRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.neighborhood.id, area_type: "Neighborhood")

    #Household
    UserElectricityRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.household.id, area_type: "House")
    UserWaterRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.household.id, area_type: "House")
    UserGasRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.household.id, area_type: "House")
    UserCarbonRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.household.id, area_type: "House")
    end
  end

  def remove_old_ranks
    self.user_electricity_rankings.destroy_all
    self.user_water_rankings.destroy_all
    self.user_gas_rankings.destroy_all
    self.user_carbon_rankings.destroy_all
  end

  def set_all_questions(hId)
    UserElectricityQuestion.create(user_id: self.id, house_id: hId)
    UserWaterQuestion.create(user_id: self.id, house_id: hId)
    UserGasQuestion.create(user_id: self.id, house_id: hId)
  end

  def remove_all_questions(hId)
    ue = UserElectricityQuestion.where(user_id: self.id, house_id: hId)[0]
    uw = UserWaterQuestion.where(user_id: self.id, house_id: hId)[0]
    ug = UserGasQuestion.where(user_id: self.id, house_id: hId)[0]
    UserElectricityQuestion.destroy(ue.id)
    UserWaterQuestion.destroy(uw.id)
    UserGasQuestion.destroy(ug.id)
  end

  def confirm_accounts
    self.email_activate
  end

end
