require 'rails_helper'

RSpec.describe NeighborhoodHelper, type: :helper do
  before :each do
    @avg = 12071.fdiv(30)
    @wavg = 409466.6
    @gavg = 10.88
    @country = Country.create(name: "Country-land")
    @region = Region.create(name: "Region-land", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
    region2 = Region.create(name: "Region-land2", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
    @city = City.create(name: "City", region_id: @region.id)
    city2 = City.create(name: "City2", region_id: @region.id)
    city3 = City.create(name: "City3", region_id: region2.id)
    @neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: @city.id)
    @neighborhood2 = Neighborhood.create(name: "Neighboring Neighborhood", city_id: @city.id)
    not_neighborhood = Neighborhood.create(name: "Outside Neighborhood same State", city_id: city2.id)
    not_neighborhood2 = Neighborhood.create(name: "Outside Neighborhood2", city_id: city3.id)
  end
  context 'neighborhood with no users' do
    it 'can access all helper methods accurately' do
      # neighborhood out of requires users (unlike region/country)
      expect(@neighborhood.out_of).to eq(0)

      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: @neighborhood.id,
                                city_id: @city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      user2 = User.create(first: 'D', last: "Johnson", email: "d.johnson@gmail.com",
                          password: 'password', generation: 3)
      house = House.create(address_id: address.id, no_residents: 2, total_sq_ft: 3000)
      UserHouse.create(house_id: house.id, user_id: user.id, move_in_date: DateTime.now - 90)
      UserHouse.create(house_id: house.id, user_id: user2.id, move_in_date: DateTime.now - 90)

      expect(@neighborhood.out_of).to eq(2)
      expect(Neighborhood.count).to eq(4)
      expect(@neighborhood.set_default_ranks).to be_valid
    end
    it 'does not set ranks automatically' do
      new_neighborhood = Neighborhood.new(name: "New neighborhood", city_id: @city.id)
      expect(new_neighborhood.water_ranking).to eq(nil)
      expect(new_neighborhood.electricity_ranking).to eq(nil)
      expect(new_neighborhood.gas_ranking).to eq(nil)
      expect(new_neighborhood.carbon_ranking).to eq(nil)

      new_neighborhood.save
      expect(new_neighborhood.water_ranking).to eq(nil)
      expect(new_neighborhood.electricity_ranking).to eq(nil)
      expect(new_neighborhood.gas_ranking).to eq(nil)
      expect(new_neighborhood.carbon_ranking).to eq(nil)

      #set defaults
      new_neighborhood.set_default_ranks
      neighborhood = Neighborhood.last
      expect(neighborhood.id).to eq(new_neighborhood.id)

      expect(neighborhood.water_ranking).to be_kind_of(WaterRanking)
      expect(neighborhood.electricity_ranking).to be_kind_of(ElectricityRanking)
      expect(neighborhood.gas_ranking).to be_kind_of(GasRanking)
      expect(neighborhood.carbon_ranking).to be_kind_of(CarbonRanking)
    end
    it 'sets ranks with nil' do
      neighborhood = Neighborhood.create(name: "New Neighborhood", city_id: @city.id)

      neighborhood.set_default_ranks
      neighborhood = Neighborhood.last
      expect(neighborhood.water_ranking.rank).to eq(nil)
      expect(neighborhood.electricity_ranking.rank).to eq(nil)
      expect(neighborhood.gas_ranking.rank).to eq(nil)
      expect(neighborhood.carbon_ranking.rank).to eq(nil)
    end
    it 'initializes with zeros as defaults for per_capita even with avg arguments' do
      neighborhood = Neighborhood.create(name: "New Neighborhood", city_id: @city.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
      neighborhood.set_default_ranks
      neighborhood.save
      expect(neighborhood.avg_daily_electricity_consumed_per_capita).to_not eq(@avg)
      expect(neighborhood.avg_daily_electricity_consumed_per_capita).to eq(0.0)
    end
  end
  context 'neighborhood with users' do
    it 'updates totals accurately via individual method (electricity)' do
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: @neighborhood.id,
                                city_id: @city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      UserHouse.create(house_id: house.id, user_id: user.id, move_in_date: DateTime.now - 90)


      #although initializing with zeros, it can be updated
      expect(@neighborhood.avg_daily_electricity_consumed_per_capita.to_f.round(6)).to eq(0.0)
      expect(@neighborhood.avg_daily_electricity_consumed_per_user.to_f.round(6)).to eq(0.0)
      @neighborhood.update(avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
      @neighborhood.save
      expect(@neighborhood.avg_daily_electricity_consumed_per_capita.to_f.round(6)).to eq(@avg.to_f.round(6))
      expect(@neighborhood.avg_daily_electricity_consumed_per_user.to_f.round(6)).to eq(0.0)

      expect(user.neighborhood).to eq(@neighborhood)
      kwhs = 1400
      price = rand(1..100)
      ElectricBill.create(start_date: start_date1, end_date: end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first

      c1_avg = @neighborhood.avg_daily_electricity_consumed_per_user
      u_avg = user.avg_daily_electricity_consumption

      #regional per_user average is not same as per_user by default
      expect(c1_avg.to_f.round(5)).to eq(0.0)
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(c1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #regional per_user average changes to internal users' upon update
      @neighborhood.update_daily_avg_electricity_consumption
      c1_avg = @neighborhood.avg_daily_electricity_consumed_per_user
      expect(c1_avg.to_f.round(5)).to_not eq(@avg.to_f.round(5))

      #area average == user average
      expect(c1_avg).to eq(u_avg)

      #regional water and gas consumption scores left unaffected
      w_consumption = @neighborhood.avg_daily_water_consumed_per_user
      g_consumption = @neighborhood.avg_daily_gas_consumed_per_user
      expect(w_consumption.to_f.round(3)).to eq(0.0)
      expect(g_consumption.to_f.round(3)).to eq(0.0)
    end
    it 'updates totals accurately via individual method (water)' do
      county = County.create(name: "County-within", region_id: @region.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: @neighborhood.id,
                                county_id: county.id,
                                city_id: @city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      UserHouse.create(house_id: house.id, user_id: user.id, move_in_date: DateTime.now - 90)

      expect(@neighborhood.avg_daily_water_consumed_per_capita.to_f).to eq(0.0)
      expect(@neighborhood.avg_daily_water_consumed_per_user.to_f).to eq(0.0)

      expect(user.neighborhood).to eq(@neighborhood)
      gals = 1400
      price = rand(1..100)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gals, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      c1_avg = @neighborhood.avg_daily_water_consumed_per_user
      u_avg = user.avg_daily_water_consumption

      #regional per_user average is same as per_capita by default
      expect(c1_avg.to_f.round(5)).to eq(0.0)
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(c1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #regional per_user average changes to internal users' upon update
      @neighborhood.update_daily_avg_water_consumption
      c1_avg = @neighborhood.avg_daily_water_consumed_per_user
      expect(c1_avg.to_f.round(5)).to_not eq(@wavg.to_f.round(5))
      #area average == user average
      expect(c1_avg).to eq(u_avg)

      #regional water and gas consumption scores left unaffected
      g_consumption = @neighborhood.avg_daily_gas_consumed_per_user
      e_consumption = @neighborhood.avg_daily_electricity_consumed_per_user
      expect(g_consumption.to_f.round(3)).to eq(0.0)
      expect(e_consumption.to_f.round(3)).to eq(0.0)
    end
    it 'updates totals accurately via individual method (gas)' do
      county = County.create(name: "County-within", region_id: @region.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: @neighborhood.id,
                                county_id: county.id,
                                city_id: @city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      UserHouse.create(house_id: house.id, user_id: user.id, move_in_date: DateTime.now - 90)


      expect(@neighborhood.avg_daily_gas_consumed_per_capita.to_f.round(6)).to eq(0.0)
      expect(@neighborhood.avg_daily_gas_consumed_per_user.to_f.round(6)).to eq(0.0)

      expect(user.neighborhood).to eq(@neighborhood)
      therms = 1400
      price = rand(1..100)
      HeatBill.create(start_date: start_date1, end_date: end_date1, total_therms: therms, price: price, house_id: house.id, no_residents: 2, user_id: user.id, force: true)

      user = User.first
      c1_avg = @neighborhood.avg_daily_gas_consumed_per_user
      u_avg = user.avg_daily_gas_consumption

      #regional per_user average is not same as per_user by default
      expect(c1_avg.to_f.round(5)).to eq(0.0)
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(c1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #regional per_user average changes to internal users' upon update
      @neighborhood.update_daily_avg_gas_consumption
      c1_avg = @neighborhood.avg_daily_gas_consumed_per_user
      expect(c1_avg.to_f.round(5)).to_not eq(@avg.to_f.round(5))

      #area average == user average
      expect(c1_avg).to eq(u_avg)

      #regional water and gas consumption scores left unaffected
      w_consumption = @neighborhood.avg_daily_water_consumed_per_user
      e_consumption = @neighborhood.avg_daily_electricity_consumed_per_user
      expect(w_consumption.to_f.round(3)).to eq(0.0)
      expect(e_consumption.to_f.round(3)).to eq(0.0)
    end
    it 'update all zeros data however and erases per_capita/per_user link' do
      county = County.create(name: "County-within", region_id: @region.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: @neighborhood.id,
                                county_id: county.id,
                                city_id: @city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      UserHouse.create(house_id: house.id, user_id: user.id, move_in_date: DateTime.now - 90)

      expect(@neighborhood.avg_daily_water_consumed_per_capita.to_f.round(6)).to eq(0.0)
      expect(@neighborhood.avg_daily_water_consumed_per_user.to_f.round(6)).to eq(0.0)
      @neighborhood.update(avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
      @neighborhood.save
      expect(@neighborhood.avg_daily_electricity_consumed_per_capita.to_f.round(6)).to eq(@avg.to_f.round(6))
      expect(@neighborhood.avg_daily_gas_consumed_per_capita.to_f.round(6)).to eq(@gavg.to_f.round(6))


      expect(user.neighborhood).to eq(@neighborhood)
      gals = 1400
      price = rand(1..100)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gals, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      c1_avg = @neighborhood.avg_daily_water_consumed_per_user
      u_avg = user.avg_daily_water_consumption

      #regional per_user average is NOT same as per_user by default
      expect(c1_avg.to_f.round(5)).to eq(0.0)
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(c1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #cannot update without running set_default_ranks
      #regional per_user average changes to internal users' upon setting ranks and update_all
      @neighborhood.set_default_ranks
      @neighborhood.update_data
      c1_avg = @neighborhood.avg_daily_water_consumed_per_user
      expect(c1_avg.to_f.round(5)).to_not eq(@wavg.to_f.round(5))
      #area average == user average
      expect(c1_avg).to eq(u_avg)

      #regional electricity and gas consumption scores stay as ZEROS
      g_consumption = @neighborhood.avg_daily_gas_consumed_per_user
      e_consumption = @neighborhood.avg_daily_electricity_consumed_per_user
      expect(g_consumption.to_f.round(3)).to eq(0.0)
      expect(e_consumption.to_f.round(3)).to eq(0.0)
    end
    it 'update all zeros data does not produce a carbon score for region' do
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: @neighborhood.id,
                                city_id: @city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      UserHouse.create(house_id: house.id, user_id: user.id, move_in_date: DateTime.now - 90)

      # all initialize with zero, both per_cap and per_user
      expect(@neighborhood.avg_daily_electricity_consumed_per_capita.to_f.round(6)).to eq(0.0)
      expect(@neighborhood.avg_daily_electricity_consumed_per_user.to_f.round(6)).to eq(0.0)
      expect(@neighborhood.avg_daily_water_consumed_per_capita.to_f.round(6)).to eq(0.0)
      expect(@neighborhood.avg_daily_water_consumed_per_user.to_f.round(6)).to eq(0.0)
      expect(@neighborhood.avg_daily_gas_consumed_per_capita.to_f.round(6)).to eq(0.0)
      expect(@neighborhood.avg_daily_gas_consumed_per_user.to_f.round(6)).to eq(0.0)

      expect(user.neighborhood).to eq(@neighborhood)
      kwhs = 1100
      gals = 1400
      therms = 18
      price = rand(1..100)
      ElectricBill.create(start_date: start_date1, end_date: end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gals, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      HeatBill.create(start_date: start_date1, end_date: end_date1, total_therms: therms, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      #no carbon_ranking until default_ranks are set, which default to 0 until the front end pings (and update) the db
      expect(@neighborhood.carbon_ranking.rank).to be(nil)

      #regional per_user average changes to internal users' upon update_all
      @neighborhood.set_default_ranks
      neighborhood = Neighborhood.first
      expect(@neighborhood.id).to eq(neighborhood.id)

      neighborhood.update_data
      c1_avg_water = neighborhood.avg_daily_water_consumed_per_user
      c1_avg_gas = neighborhood.avg_daily_gas_consumed_per_user
      c1_avg_elec = neighborhood.avg_daily_electricity_consumed_per_user
      carbon_avg = neighborhood.combine_average_use(c1_avg_elec, c1_avg_gas)

      #update changes water, elec and gas away from default, as well as carbon_ranking avg
      expect(c1_avg_water.to_f.round(5)).to_not eq(0.0)
      expect(c1_avg_gas.to_f.round(5)).to_not eq(0.0)
      expect(c1_avg_elec.to_f.round(5)).to_not eq(0.0)

      expect(c1_avg_water.to_f.round(2)).to eq(user.avg_daily_water_consumption.to_f.round(2))
      expect(c1_avg_gas.to_f.round(2)).to eq(user.avg_daily_gas_consumption.to_f.round(2))
      expect(c1_avg_elec.to_f.round(2)).to eq(user.avg_daily_electricity_consumption.to_f.round(2))
      
      expect(neighborhood.avg_daily_carbon_consumed_per_user).to eq(carbon_avg)
      expect(neighborhood.avg_daily_carbon_consumed_per_user).to eq(user.avg_daily_carbon_consumption)
    end
  end
end
