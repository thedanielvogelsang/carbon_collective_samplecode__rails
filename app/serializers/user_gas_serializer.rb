class UserGasSerializer < ActiveModel::Serializer
  attributes :id, :avg_daily_consumption, :first, :last, :email,
                  :avatar_url, :house_ids, :avg_monthly_consumption,
                  :privacy_policy, :house, :house_max,
                  :rank, :arrow, :last_updated,
                  :personal_usage_to_date, :personal_savings_to_date,
                  :avg_daily_footprint, :avg_monthly_footprint, :personal,
                  :household, :neighborhood, :city, :county, :region, :country,
                  :metric_sym, :num_bills, :out_of, :move_in_date,
                  :invite_max, :slug, :checklist_completed, :bill_entered

  def avg_daily_footprint
    object.avg_daily_carbon_consumption.round(2).to_s + " lbs" if object.avg_daily_carbon_consumption
  end
  def avg_monthly_footprint
    object.avg_daily_carbon_consumption.round(2).to_s + " lbs" if object.avg_daily_carbon_consumption
  end

  def house
    object.household
  end
  def house_max
    object.household.house_max("gas") if object.household
  end

  def personal
    h = object.household
    if h
    avg_monthly = (object.avg_daily_gas_consumption * 29.53).round(2)
    # household_avg = (h.avg_daily_gas_consumed_per_user * 29.53).round(2) if h.avg_daily_water_consumed_per_user
    # household_max = (h.calculate_house_heat_max * 29.53).round(2)
    user_max = (object.country.max_daily_user_gas_consumption * 29.53).round(2)
    user_avg = (object.country.avg_daily_gas_consumed_per_user * 29.53).round(2)
    # user_house_rank = object.user_gas_rankings.where(area_type: "House").first.rank
    # user_house_arrow = object.user_gas_rankings.where(area_type: "House").first.arrow
    #

    user_rank = object.user_gas_rankings.where(area_type: "City").first.rank
    user_house_arrow = object.user_gas_rankings.where(area_type: "City").first.arrow
    out_of = User.joins(:user_gas_rankings).distinct.reject{|u| u.avg_daily_gas_consumption.zero?}.count
    if user_rank
      better_than = out_of - user_rank
    end
    arr = [object.id, "Me", avg_monthly,
      user_avg, user_max,
      user_rank, better_than, user_house_arrow]
    end
    arr
  end
  ## regional arrays for dash, order: [id, name, regional-avg, regional_avg, parent_max, regional-rank, out_of]
  def household
    h = object.household
    if h
      ranking = h.gas_ranking
      avg_monthly = (h.avg_daily_gas_consumed_per_user * 29.53).round(2)
      regional_avg = (h.address.neighborhood.avg_daily_gas_consumed_per_user * 29.53).round(2)
      user_max = (object.country.max_daily_user_gas_consumption * 29.53).round(2)
      # parent_max = (h.max_regional_avg_gas_consumption * 29.53).round(2)
      if ranking.rank
        better_than = ranking.out_of - ranking.rank
      end
        arr = [h.id, "Household", avg_monthly,
        regional_avg, user_max,
        ranking.rank, better_than, ranking.arrow]
    end
    arr
  end
  def neighborhood
    n = object.neighborhood
    if n
      ranking = n.gas_ranking
      avg_monthly = (n.avg_daily_gas_consumed_per_user * 29.53).round(2)
      regional_avg = (n.city.avg_daily_gas_consumed_per_user * 29.53).round(2)
      user_max = (object.country.max_daily_user_gas_consumption * 29.53).round(2)
      # parent_max = (n.max_regional_avg_gas_consumption * 29.53).round(2)
      if ranking.rank
        better_than = ranking.out_of - ranking.rank
      end
      arr = [n.id, n.name, avg_monthly,
        regional_avg, user_max,
        ranking.rank, better_than, ranking.arrow]
    end
    arr
  end
  def city
    c = object.city
    if c
      ranking = c.gas_ranking
      avg_monthly = (c.avg_daily_gas_consumed_per_user * 29.53).round(2)
      regional_avg = (c.region.avg_daily_gas_consumed_per_user * 29.53).round(2)
      user_max = (object.country.max_daily_user_gas_consumption * 29.53).round(2)
      # parent_max = (c.max_regional_avg_gas_consumption * 29.53).round(2)
      if ranking.rank
        better_than = ranking.out_of - ranking.rank
      end
      arr = [c.id, c.name, avg_monthly,
        regional_avg, user_max,
        ranking.rank, better_than, ranking.arrow]
    end
    arr
  end
  def county
    c = object.county
    if c
      ranking = c.gas_ranking
      avg_monthly = (c.avg_daily_gas_consumed_per_user * 29.53).round(2)
      regional_avg = (c.region.avg_daily_gas_consumed_per_user * 29.53).round(2)
      user_max = (object.country.max_daily_user_gas_consumption * 29.53).round(2)
      # parent_max = (c.max_regional_avg_gas_consumption * 29.53).round(2)
      if ranking.rank
        better_than = ranking.out_of - ranking.rank
      end
      arr = [c.id, c.name, avg_monthly,
        regional_avg, user_max,
        ranking.rank, better_than, ranking.arrow]
    end
    arr
  end
  def region
    r = object.region
    if r
      ranking = r.gas_ranking
      avg_monthly = (r.avg_daily_gas_consumed_per_user * 29.53).round(2)
      regional_avg = (r.country.avg_daily_gas_consumed_per_user * 29.53).round(2)
      user_max = (object.country.max_daily_user_gas_consumption * 29.53).round(2)
      # parent_max = (r.max_regional_avg_gas_consumption * 29.53).round(2)
      if ranking.rank
        better_than = ranking.out_of - ranking.rank
      end
      arr = [r.id, r.name, avg_monthly,
        regional_avg, user_max,
        ranking.rank, better_than, ranking.arrow]
    end
    arr
  end
  def country
    c = object.country
    ## out of for country is 'inaccurate' but using all countries, not just ones with users
    if c
      ranking = c.gas_ranking
      country_avg_gas = Country.average(:avg_daily_gas_consumed_per_user)
      avg_monthly = (c.avg_daily_gas_consumed_per_user * 29.53).round(2)
      regional_avg = (country_avg_gas * 29.53).round(2)
      # user_max = (object.country.max_daily_user_gas_consumption * 29.53).round(2)
      if ranking.rank
        better_than = ranking.out_of - ranking.rank
      end
      parent_max = (c.max_regional_avg_gas_consumption * 29.53).round(2)
      arr = [c.id, c.name, avg_monthly,
        regional_avg, parent_max,
        ranking.rank, better_than, ranking.arrow]
    end
    arr
  end
  def house_ids
    object.houses.map{|h| h.id} if object.houses.length > 0
  end

  def personal_usage_to_date
    object.total_therms_logged.to_f.round(2).to_s
  end

  def personal_savings_to_date
    object.total_gas_savings.to_f.round(2).to_s
  end
  #
  # def global_collective_savings
  #   nil
  # end

  def current_location
    object.location
  end

  def trip_count
    object.trips.count
  end

  def admins
    admins = {}
    Group.joins(:admin)
         .where(:admins => {user_id: object.id})
         .each_with_index{|g,i| admins[i+1] = g.name}
    admins
  end

  def avatar_url
    object.url
  end

  def household_daily_consumption
    object.household_daily_gas_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end
  def neighborhood_daily_consumption
    object.neighborhood_daily_gas_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end
  def city_daily_consumption
    object.city_daily_gas_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end
  def county_daily_consumption
    object.county_daily_gas_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end
  def region_daily_consumption
    object.region_daily_gas_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end
  def country_daily_consumption
    object.country_daily_gas_consumption_per_user.to_f.round(2).to_s if !object.houses.empty?
  end
  def avg_daily_consumption
    avg = object.avg_daily_gas_consumption.to_f
    avg.nan? ? "0" : avg.round(2).to_s
  end

  #monthly averages
  def household_monthly_consumption
    (object.household_daily_gas_consumption_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end
  def neighborhood_monthly_consumption
    (object.neighborhood_daily_gas_consumption_per_user * 29.53).to_f.round(2).to_s if !object.houses.empty?
  end
  def city_monthly_consumption
    (object.city_daily_gas_consumption_per_user.to_f * 29.53).round(2).to_s if !object.houses.empty?
  end
  def county_monthly_consumption
    (object.county_daily_gas_consumption_per_user.to_f * 29.53).round(2).to_s if !object.houses.empty?
  end
  def region_monthly_consumption
    (object.region_daily_gas_consumption_per_user.to_f * 29.53).round(2).to_s if !object.houses.empty?
  end
  def country_monthly_consumption
    (object.country_daily_gas_consumption_per_user.to_f * 29.53).round(2).to_s if !object.houses.empty?
  end
  def avg_monthly_consumption
    avg = (object.avg_daily_gas_consumption * 29.53).to_f
    avg.nan? ? "0" : avg.round(2).to_s
  end

  def arrow
    ops__ = @instance_options[:region]
    if ops__
      object.user_gas_rankings
        .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].arrow
    else
      nil
    end
  end

  def rank
    ops__ = @instance_options[:region]
    if ops__
      object.user_gas_rankings
        .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].rank
    else
      nil
    end
  end

  def last_updated
    ops__ = @instance_options[:region]
    if ops__
    object.user_gas_rankings
          .where(area_type: ops__[:area_type], area_id: ops__[:area_id])[0].updated_at
    else
      nil
    end
  end
  def metric_sym
    'therms'
  end
  def num_bills
    object.heat_bills_by_house(object.household.id).count if object.household
  end

  def out_of
    ops_ = @instance_options[:region] if @instance_options[:region]
    if ops_
      if ops_[:area_type] == "County"
        c = County.find(ops_[:area_id])
        County.where(region: c.region).count
      elsif ops_[:area_type] == "Neighborhood"
        n = Neighborhood.find(ops_[:area_id])
        Neighborhood.where(city: n.city).count
      elsif ops_[:area_type] == "City"
        c = City.find(ops_[:area_id])
        City.where(region: c.region).count
      elsif ops_[:area_type] == "Region"
        r = Region.find(ops_[:area_id])
        Region.where(country: r.country).count
      elsif ops_[:area_type] == "Country"
        Country.count
      end
    else
      nil
    end
  end

  def move_in_date
    UserHouse.where(user_id: object.id, house_id: object.household.id).first.move_in_date
  end

  def checklist_completed
    object.user_gas_questions.first.completed?
  end

  def all_checklist
    e = object.user_electricity_questions.first.completed?
    w = object.user_water_questions.first.completed?
    g = object.user_gas_questions.first.completed?
    e && w && g
  end

  def bill_entered
    if object.household
      return object.household.heat_bills.count > 0 ? true : false
    else
      false
    end
  end
end
