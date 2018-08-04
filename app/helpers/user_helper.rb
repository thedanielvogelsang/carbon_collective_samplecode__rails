module UserHelper

    def immediate_parent
      if self.parent
        UserGeneration.where(child_id: self.id).order(id: :asc).first.parent
      end
    end

    def all_children
      array = Array.new
      array << self.children.map do |child|
          get_childrens_children(child)
        end
      if !array.empty?
        array.flatten.compact.uniq.sort{|u1, u2| u1.id <=> u2.id}
      else
        array
      end
    end

    def get_childrens_children(child)
      if !child.children.empty?
        kids = child.children.map{|user| get_childrens_children(user)}
                .unshift(child)
      else
        child
      end
    end

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
    if self.user_electricity_rankings.empty? && self.user_water_rankings.empty? && self.user_gas_rankings.empty?
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
    if self.county
      UserElectricityRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.county.id, area_type: "County")
      UserWaterRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.county.id, area_type: "County")
      UserGasRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.county.id, area_type: "County")
      UserCarbonRanking.create(user_id: self.id, rank: nil, arrow: nil, area_id: self.county.id, area_type: "County")
    end
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

  def clear_totals
    self.total_kwhs_logged = 0.0;
    self.total_electricitybill_days_logged = 0;
    self.total_gallons_logged = 0.0;
    self.total_waterbill_days_logged = 0;
    self.total_therms_logged = 0.0;
    self.total_heatbill_days_logged = 0;
    self.save
  end

  def confirm_accounts
    self.email_activate
  end

end
