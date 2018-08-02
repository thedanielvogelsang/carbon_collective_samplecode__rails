require 'rails_helper'

RSpec.describe CityHelper, type: :helper do
  before :each do
    @avg = 12071.fdiv(30)
    @wavg = 409466.6
    @gavg = 10.88
    @country = Country.create(name: "Country-land")
    @region = Region.create(name: "Region-land", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
    region2 = Region.create(name: "Region-land2", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
    @city = City.create(name: "City", region_id: @region.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
    @city2 = City.create(name: "City2", region_id: @region.id)
    not_city = City.create(name: "City3", region_id: region2.id)
  end
  context 'city with no users' do
    it 'can access all helper methods accurately' do
      # city out of requires users (unlike region/country)
      expect(@city.out_of).to eq(0)
      expect(City.count).to eq(3)
      expect(@city.set_default_ranks).to be_valid
    end
    it 'does not set ranks automatically' do
      new_city = City.new(name: "New City",region_id: @region.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
      expect(new_city.water_ranking).to eq(nil)
      expect(new_city.electricity_ranking).to eq(nil)
      expect(new_city.gas_ranking).to eq(nil)
      expect(new_city.carbon_ranking).to eq(nil)

      new_city.save
      expect(new_city.water_ranking).to eq(nil)
      expect(new_city.electricity_ranking).to eq(nil)
      expect(new_city.gas_ranking).to eq(nil)
      expect(new_city.carbon_ranking).to eq(nil)

      #set defaults
      new_city.set_default_ranks
      city = City.last
      expect(city.id).to eq(new_city.id)

      expect(city.water_ranking).to be_kind_of(WaterRanking)
      expect(city.electricity_ranking).to be_kind_of(ElectricityRanking)
      expect(city.gas_ranking).to be_kind_of(GasRanking)
      expect(city.carbon_ranking).to be_kind_of(CarbonRanking)
    end
    it 'sets ranks with nil' do
      city = City.create(name: "New City", region_id: @region.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)

      city.set_default_ranks
      city = City.last
      expect(city.water_ranking.rank).to eq(nil)
      expect(city.electricity_ranking.rank).to eq(nil)
      expect(city.gas_ranking.rank).to eq(nil)
      expect(city.carbon_ranking.rank).to eq(nil)
    end
    it 'initializes with zeros as defaults for per_capita even with avg arguments' do
      city = City.create(name: "New City", region_id: @region.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
      city.set_default_ranks
      city.save
      expect(city.avg_daily_electricity_consumed_per_capita).to_not eq(@avg)
      expect(city.avg_daily_electricity_consumed_per_capita).to eq(0.0)
    end
  end
  context 'city with users' do
    it 'updates totals accurately via individual method (electricity)' do
      neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: @city.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: neighborhood.id,
                                city_id: @city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      user.houses << house

      #although initializing with zeros, it can be updated
      expect(@city.avg_daily_electricity_consumed_per_capita.to_f.round(6)).to eq(0.0)
      expect(@city.avg_daily_electricity_consumed_per_user.to_f.round(6)).to eq(0.0)
      @city.update(avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
      @city.save
      expect(@city.avg_daily_electricity_consumed_per_capita.to_f.round(6)).to eq(@avg.to_f.round(6))
      expect(@city.avg_daily_electricity_consumed_per_user.to_f.round(6)).to eq(0.0)

      expect(user.city).to eq(@city)
      kwhs = 1400
      price = rand(1..100)
      ElectricBill.create(start_date: start_date1, end_date: end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first

      c1_avg = @city.avg_daily_electricity_consumed_per_user
      u_avg = user.avg_daily_electricity_consumption

      #regional per_user average is not same as per_user by default
      expect(c1_avg.to_f.round(5)).to eq(0.0)
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(c1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #regional per_user average changes to internal users' upon update
      @city.update_daily_avg_electricity_consumption
      c1_avg = @city.avg_daily_electricity_consumed_per_user
      expect(c1_avg.to_f.round(5)).to_not eq(@avg.to_f.round(5))

      #area average == user average
      expect(c1_avg).to eq(u_avg)

      #regional water and gas consumption scores left unaffected
      w_consumption = @city.avg_daily_water_consumed_per_user
      g_consumption = @city.avg_daily_gas_consumed_per_user
      expect(w_consumption.to_f.round(3)).to eq(0.0)
      expect(g_consumption.to_f.round(3)).to eq(0.0)
    end
    it 'updates totals accurately via individual method (water)' do
      county = County.create(name: "County-within", region_id: @region.id)
      neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: @city.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: neighborhood.id,
                                county_id: county.id,
                                city_id: @city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      user.houses << house

      expect(@city.avg_daily_water_consumed_per_capita.to_f).to eq(0.0)
      expect(@city.avg_daily_water_consumed_per_user.to_f).to eq(0.0)

      expect(user.city).to eq(@city)
      gals = 1400
      price = rand(1..100)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gals, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      c1_avg = @city.avg_daily_water_consumed_per_user
      u_avg = user.avg_daily_water_consumption

      #regional per_user average is same as per_capita by default
      expect(c1_avg.to_f.round(5)).to eq(0.0)
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(c1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #regional per_user average changes to internal users' upon update
      @city.update_daily_avg_water_consumption
      c1_avg = @city.avg_daily_water_consumed_per_user
      expect(c1_avg.to_f.round(5)).to_not eq(@wavg.to_f.round(5))
      #area average == user average
      expect(c1_avg).to eq(u_avg)

      #regional water and gas consumption scores left unaffected
      g_consumption = @city.avg_daily_gas_consumed_per_user
      e_consumption = @city.avg_daily_electricity_consumed_per_user
      expect(g_consumption.to_f.round(3)).to eq(0.0)
      expect(e_consumption.to_f.round(3)).to eq(0.0)
    end
    it 'updates totals accurately via individual method (gas)' do
      county = County.create(name: "County-within", region_id: @region.id)
      neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: @city.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: neighborhood.id,
                                county_id: county.id,
                                city_id: @city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      user.houses << house

      expect(@city.avg_daily_gas_consumed_per_capita.to_f.round(6)).to eq(0.0)
      expect(@city.avg_daily_gas_consumed_per_user.to_f.round(6)).to eq(0.0)

      expect(user.city).to eq(@city)
      therms = 1400
      price = rand(1..100)
      HeatBill.create(start_date: start_date1, end_date: end_date1, total_therms: therms, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      c1_avg = @city.avg_daily_gas_consumed_per_user
      u_avg = user.avg_daily_gas_consumption

      #regional per_user average is not same as per_user by default
      expect(c1_avg.to_f.round(5)).to eq(0.0)
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(c1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #regional per_user average changes to internal users' upon update
      @city.update_daily_avg_gas_consumption
      c1_avg = @city.avg_daily_gas_consumed_per_user
      expect(c1_avg.to_f.round(5)).to_not eq(@avg.to_f.round(5))

      #area average == user average
      expect(c1_avg).to eq(u_avg)

      #regional water and gas consumption scores left unaffected
      w_consumption = @city.avg_daily_water_consumed_per_user
      e_consumption = @city.avg_daily_electricity_consumed_per_user
      expect(w_consumption.to_f.round(3)).to eq(0.0)
      expect(e_consumption.to_f.round(3)).to eq(0.0)
    end
    it 'update all zeros data however and erases per_capita/per_user link' do
      county = County.create(name: "County-within", region_id: @region.id)
      neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: @city.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: neighborhood.id,
                                county_id: county.id,
                                city_id: @city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      user.houses << house

      expect(@city.avg_daily_water_consumed_per_capita.to_f.round(6)).to eq(0.0)
      expect(@city.avg_daily_water_consumed_per_user.to_f.round(6)).to eq(0.0)
      @city.update(avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
      @city.save
      expect(@city.avg_daily_electricity_consumed_per_capita.to_f.round(6)).to eq(@avg.to_f.round(6))
      expect(@city.avg_daily_gas_consumed_per_capita.to_f.round(6)).to eq(@gavg.to_f.round(6))


      expect(user.city).to eq(@city)
      gals = 1400
      price = rand(1..100)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gals, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      c1_avg = @city.avg_daily_water_consumed_per_user
      u_avg = user.avg_daily_water_consumption

      #regional per_user average is NOT same as per_user by default
      expect(c1_avg.to_f.round(5)).to eq(0.0)
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(c1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #cannot update without running set_default_ranks
      #regional per_user average changes to internal users' upon setting ranks and update_all
      @city.set_default_ranks
      @city.update_data
      c1_avg = @city.avg_daily_water_consumed_per_user
      expect(c1_avg.to_f.round(5)).to_not eq(@wavg.to_f.round(5))
      #area average == user average
      expect(c1_avg).to eq(u_avg)

      #regional electricity and gas consumption scores stay as ZEROS
      g_consumption = @city.avg_daily_gas_consumed_per_user
      e_consumption = @city.avg_daily_electricity_consumed_per_user
      expect(g_consumption.to_f.round(3)).to eq(0.0)
      expect(e_consumption.to_f.round(3)).to eq(0.0)
    end
    it 'update all zeros data does not produce a carbon score for region' do
      neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: @city.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: neighborhood.id,
                                city_id: @city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      user.houses << house

      # all initialize with zero, both per_cap and per_user
      expect(@city.avg_daily_electricity_consumed_per_capita.to_f.round(6)).to eq(0.0)
      expect(@city.avg_daily_electricity_consumed_per_user.to_f.round(6)).to eq(0.0)
      expect(@city.avg_daily_water_consumed_per_capita.to_f.round(6)).to eq(0.0)
      expect(@city.avg_daily_water_consumed_per_user.to_f.round(6)).to eq(0.0)
      expect(@city.avg_daily_gas_consumed_per_capita.to_f.round(6)).to eq(0.0)
      expect(@city.avg_daily_gas_consumed_per_user.to_f.round(6)).to eq(0.0)

      expect(user.city).to eq(@city)
      kwhs = 1100
      gals = 1400
      therms = 18
      price = rand(1..100)
      ElectricBill.create(start_date: start_date1, end_date: end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gals, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      HeatBill.create(start_date: start_date1, end_date: end_date1, total_therms: therms, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      #no carbon_ranking until default_ranks are set, which default to 0 until the front end pings (and update) the db
      expect(@city.carbon_ranking).to be(nil)

      #regional per_user average changes to internal users' upon update_all
      @city.set_default_ranks
      city = City.first
      expect(@city.id).to eq(city.id)

      city.update_data
      c1_avg_water = city.avg_daily_water_consumed_per_user
      c1_avg_gas = city.avg_daily_gas_consumed_per_user
      c1_avg_elec = city.avg_daily_electricity_consumed_per_user
      carbon_avg = city.combine_average_use(c1_avg_elec, c1_avg_gas)

      #update changes water, elec and gas away from default, as well as carbon_ranking avg
      expect(c1_avg_water.to_f.round(5)).to_not eq(0.0)
      expect(c1_avg_gas.to_f.round(5)).to_not eq(0.0)
      expect(c1_avg_elec.to_f.round(5)).to_not eq(0.0)

      expect(c1_avg_water.to_f.round(2)).to eq(user.avg_daily_water_consumption.to_f.round(2))
      expect(c1_avg_gas.to_f.round(2)).to eq(user.avg_daily_gas_consumption.to_f.round(2))
      expect(c1_avg_elec.to_f.round(2)).to eq(user.avg_daily_electricity_consumption.to_f.round(2))

      expect(city.carbon_ranking.avg_daily_carbon_consumed_per_user).to eq(carbon_avg)
      expect(city.carbon_ranking.avg_daily_carbon_consumed_per_user).to eq(user.avg_daily_carbon_consumption)
    end
  end
end
