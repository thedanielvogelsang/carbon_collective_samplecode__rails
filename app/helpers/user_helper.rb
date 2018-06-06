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
    UserElectricityRanking.create(user_id: self.id, rank: nil, arrow: nil)
    UserWaterRanking.create(user_id: self.id, rank: nil, arrow: nil)
    UserGasRanking.create(user_id: self.id, rank: nil, arrow: nil)
    UserCarbonRanking.create(user_id: self.id, rank: nil, arrow: nil)
  end

  def confirm_accounts
    self.email_activate
  end

end
