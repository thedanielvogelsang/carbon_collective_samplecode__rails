module UserHelper

    INVITE_MAX = 3

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

  def set_default_ranks(new_house_id)
    house = House.find(new_house_id)
      address = house.address
      country = address.country
      region = address.region
      city = address.city
      neighborhood = address.neighborhood
      county = address.county
      #Country
        set_rank("Country", country.id)
      #Region
        set_rank("Region", region.id)
      #County
      if county
        set_rank("County", county.id)
      end
      #City
        set_rank("City", city.id)
      #Neighborhood
        set_rank("Neighborhood", neighborhood.id)
      #Household
        set_rank("House", house.id)
  end

  def set_rank(res_type, id)
    UserElectricityRanking.find_or_create_by(user_id: self.id, rank: nil, arrow: nil, area_id: id, area_type: res_type)
    UserWaterRanking.find_or_create_by(user_id: self.id, rank: nil, arrow: nil, area_id: id, area_type: res_type)
    UserGasRanking.find_or_create_by(user_id: self.id, rank: nil, arrow: nil, area_id: id, area_type: res_type)
    UserCarbonRanking.find_or_create_by(user_id: self.id, rank: nil, arrow: nil, area_id: id, area_type: res_type)
  end

  def remove_old_ranks
    self.user_electricity_rankings.destroy_all
    self.user_water_rankings.destroy_all
    self.user_gas_rankings.destroy_all
    self.user_carbon_rankings.destroy_all
  end

  def set_all_questions(hId)
    UserElectricityQuestion.find_or_create_by(user_id: self.id, house_id: hId)
    UserGasQuestion.find_or_create_by(user_id: self.id, house_id: hId)
    UserWaterQuestion.find_or_create_by(user_id: self.id, house_id: hId)
    true
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

  def invites
    UserInvite.where(user_id: self.id).map{|ui| ui.invited }
  end

end
