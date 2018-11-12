require 'rails_helper'

RSpec.describe RegionHelper, type: :helper do
  before :each do
    @avg = 12071.fdiv(30)
    @wavg = 409466.6
    @gavg = 10.88
    @country = Country.create(name: "Country-land")
    country2 = Country.create(name: "Different Country")
    @region = Region.create(name: "Region-land", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
    region2 = Region.create(name: "Region-land2", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
    region3 = Region.create(name: "Region-land3", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
    region4 = Region.create(name: "Region-land4", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
    region5 = Region.create(name: "Region-land5", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
    non_region = Region.create(name: "NonRegion", country_id: country2.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
  end
  context 'region with no users' do
    it 'can access all helper methods accurately' do
      expect(@region.out_of).to eq(5)
      expect(Region.count).to eq(6)
      expect(@region.set_default_ranks).to be_valid
    end
    it 'does not set ranks automatically' do
      region = Region.new(name: "New Region", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
      expect(region.water_ranking).to eq(nil)
      expect(region.electricity_ranking).to eq(nil)
      expect(region.gas_ranking).to eq(nil)
      expect(region.carbon_ranking).to eq(nil)

      region.save
      expect(region.water_ranking).to eq(nil)
      expect(region.electricity_ranking).to eq(nil)
      expect(region.gas_ranking).to eq(nil)
      expect(region.carbon_ranking).to eq(nil)

      #set defaults
      region.set_default_ranks
      region = Region.last

      expect(region.water_ranking).to be_kind_of(WaterRanking)
      expect(region.electricity_ranking).to be_kind_of(ElectricityRanking)
      expect(region.gas_ranking).to be_kind_of(GasRanking)
      expect(region.carbon_ranking).to be_kind_of(CarbonRanking)
    end
    it 'sets ranks with nil' do
      region = Region.create(name: "New Region", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)

      region.set_default_ranks
      region = Region.last
      expect(region.water_ranking.rank).to eq(nil)
      expect(region.electricity_ranking.rank).to eq(nil)
      expect(region.gas_ranking.rank).to eq(nil)
      expect(region.carbon_ranking.rank).to eq(nil)
    end
    it 'from United States can be created from abbreviation (caps only)' do
      r = Region.new(name: "CA")
      expect(r.check_abbreviation).to eq("California")
      r.save
      expect(r.name).to eq("California")

      s = Region.new(name: "SH")
      expect(s.check_abbreviation).to eq(nil)
      s.save
      expect(s.name).to eq("Sh")
    end
  end
  context 'region with users' do
    it 'updates totals accurately via individual method (electricity)' do
      city = City.create(name: "City", region_id: @region.id)
      county = County.create(name: "County-within", region_id: @region.id)
      neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: city.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: neighborhood.id,
                                county_id: county.id,
                                city_id: city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      UserHouse.create(house_id: house.id, user_id: user.id, move_in_date: DateTime.now - 90)

      expect(@region.avg_daily_electricity_consumed_per_capita.to_f.round(6)).to eq(@avg.round(6))
      expect(@region.avg_daily_electricity_consumed_per_user.to_f.round(6)).to eq(@avg.round(6))

      expect(user.region).to eq(@region)
      kwhs = 1400
      price = rand(1..100)
      ElectricBill.create(start_date: start_date1, end_date: end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      c1_avg = @region.avg_daily_electricity_consumed_per_user
      u_avg = user.avg_daily_electricity_consumption

      #regional per_user average is same as per_capita by default
      expect(c1_avg.to_f.round(5)).to eq(@avg.to_f.round(5))
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(c1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))
      @region.update_daily_avg_electricity_consumption

      #regional per_user average changes to internal users' upon update
      c1_avg = @region.avg_daily_electricity_consumed_per_user
      expect(c1_avg.to_f.round(5)).to_not eq(@avg.to_f.round(5))
      #area average == user average
      expect(c1_avg).to eq(u_avg)

      #regional water and gas consumption scores left unaffected
      w_consumption = @region.avg_daily_water_consumed_per_user
      g_consumption = @region.avg_daily_gas_consumed_per_user
      expect(w_consumption.to_f.round(3)).to eq(@wavg.to_f.round(3))
      expect(g_consumption.to_f.round(3)).to eq(@gavg.to_f.round(3))
    end
    it 'updates totals accurately via individual method (water)' do
      city = City.create(name: "City", region_id: @region.id)
      county = County.create(name: "County-within", region_id: @region.id)
      neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: city.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: neighborhood.id,
                                county_id: county.id,
                                city_id: city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      UserHouse.create(house_id: house.id, user_id: user.id, move_in_date: DateTime.now - 90)

      expect(@region.avg_daily_water_consumed_per_capita.to_f.round(6)).to eq(@wavg.round(6))
      expect(@region.avg_daily_water_consumed_per_user.to_f.round(6)).to eq(@wavg.round(6))

      expect(user.region).to eq(@region)
      gals = 1400
      price = rand(1..100)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gals, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      r1_avg = @region.avg_daily_water_consumed_per_user
      u_avg = user.avg_daily_water_consumption

      #regional per_user average is same as per_capita by default
      expect(r1_avg.to_f.round(5)).to eq(@wavg.to_f.round(5))
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(r1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #regional per_user average changes to internal users' upon update
      @region.update_daily_avg_water_consumption
      r1_avg = @region.avg_daily_water_consumed_per_user
      expect(r1_avg.to_f.round(5)).to_not eq(@wavg.to_f.round(5))
      #area average == user average
      expect(r1_avg).to eq(u_avg)

      #regional water and gas consumption scores left unaffected
      g_consumption = @region.avg_daily_gas_consumed_per_user
      e_consumption = @region.avg_daily_electricity_consumed_per_user
      expect(g_consumption.to_f.round(3)).to eq(@gavg.to_f.round(3))
      expect(e_consumption.to_f.round(3)).to eq(@avg.to_f.round(3))
    end
    it 'updates totals accurately via individual method (gas)' do
      city = City.create(name: "City", region_id: @region.id)
      county = County.create(name: "County-within", region_id: @region.id)
      neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: city.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: neighborhood.id,
                                county_id: county.id,
                                city_id: city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      UserHouse.create(house_id: house.id, user_id: user.id, move_in_date: DateTime.now - 90)

      expect(@region.avg_daily_gas_consumed_per_capita.to_f.round(6)).to eq(@gavg.round(6))
      expect(@region.avg_daily_gas_consumed_per_user.to_f.round(6)).to eq(@gavg.round(6))

      expect(user.region).to eq(@region)
      therms = 1400
      price = rand(1..100)
      HeatBill.create(start_date: start_date1, end_date: end_date1, total_therms: therms, price: price, house_id: house.id, no_residents: 2, user_id: user.id, force: true)

      user = User.first
      r1_avg = @region.avg_daily_gas_consumed_per_user
      u_avg = user.avg_daily_gas_consumption

      #regional per_user average is same as per_capita by default
      expect(r1_avg.to_f.round(5)).to eq(@gavg.to_f.round(5))
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(r1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #regional per_user average changes to internal users' upon update
      @region.update_daily_avg_gas_consumption
      r1_avg = @region.avg_daily_gas_consumed_per_user
      expect(r1_avg.to_f.round(5)).to_not eq(@avg.to_f.round(5))
      #area average == user average
      expect(r1_avg).to eq(u_avg)

      #regional water and gas consumption scores left unaffected
      w_consumption = @region.avg_daily_water_consumed_per_user
      e_consumption = @region.avg_daily_electricity_consumed_per_user
      expect(w_consumption.to_f.round(3)).to eq(@wavg.to_f.round(3))
      expect(e_consumption.to_f.round(3)).to eq(@avg.to_f.round(3))
    end
    it 'update all zeros data however and erases per_capita/per_user link' do
      city = City.create(name: "City", region_id: @region.id)
      county = County.create(name: "County-within", region_id: @region.id)
      neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: city.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: neighborhood.id,
                                county_id: county.id,
                                city_id: city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      UserHouse.create(house_id: house.id, user_id: user.id, move_in_date: DateTime.now - 90)

      expect(@region.avg_daily_water_consumed_per_capita.to_f.round(6)).to eq(@wavg.round(6))
      expect(@region.avg_daily_water_consumed_per_user.to_f.round(6)).to eq(@wavg.round(6))

      expect(user.region).to eq(@region)
      gals = 1400
      price = rand(1..100)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gals, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      r1_avg = @region.avg_daily_water_consumed_per_user
      u_avg = user.avg_daily_water_consumption

      #regional per_user average is same as per_capita by default
      expect(r1_avg.to_f.round(5)).to eq(@wavg.to_f.round(5))
    end
    it 'update all zeros data however and erases per_capita/per_user link' do
      city = City.create(name: "City", region_id: @region.id)
      county = County.create(name: "County-within", region_id: @region.id)
      neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: city.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: neighborhood.id,
                                county_id: county.id,
                                city_id: city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      UserHouse.create(house_id: house.id, user_id: user.id, move_in_date: DateTime.now - 90)

      expect(@region.avg_daily_water_consumed_per_capita.to_f.round(6)).to eq(@wavg.round(6))
      expect(@region.avg_daily_water_consumed_per_user.to_f.round(6)).to eq(@wavg.round(6))

      expect(user.region).to eq(@region)
      gals = 1400
      price = rand(1..100)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gals, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      r1_avg = @region.avg_daily_water_consumed_per_user
      u_avg = user.avg_daily_water_consumption

      #regional per_user average is same as per_capita by default
      expect(r1_avg.to_f.round(5)).to eq(@wavg.to_f.round(5))
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(r1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #regional per_user average changes to internal users' upon update_all
      @region.update_data
      r1_avg = @region.avg_daily_water_consumed_per_user
      expect(r1_avg.to_f.round(5)).to_not eq(@wavg.to_f.round(5))
      #area average == user average
      expect(r1_avg).to eq(u_avg)

      #regional water and gas consumption scores changeo to ZEROS
      g_consumption = @region.avg_daily_gas_consumed_per_user
      e_consumption = @region.avg_daily_electricity_consumed_per_user
      expect(g_consumption.to_f.round(3)).to eq(0.0)
      expect(e_consumption.to_f.round(3)).to eq(0.0)
    end
    it 'update all zeros data does not produce a carbon score for region' do
      city = City.create(name: "City", region_id: @region.id)
      county = County.create(name: "County-within", region_id: @region.id)
      neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: city.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: neighborhood.id,
                                county_id: county.id,
                                city_id: city.id,
                                )
      user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                          password: 'password', generation: 1)
      house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
      UserHouse.create(house_id: house.id, user_id: user.id, move_in_date: DateTime.now - 90)

      expect(@region.avg_daily_water_consumed_per_capita.to_f.round(6)).to eq(@wavg.round(6))
      expect(@region.avg_daily_water_consumed_per_user.to_f.round(6)).to eq(@wavg.round(6))

      expect(user.region).to eq(@region)
      kwhs = 1100
      gals = 1400
      therms = 18
      price = rand(1..100)
      ElectricBill.create(start_date: start_date1, end_date: end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gals, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      HeatBill.create(start_date: start_date1, end_date: end_date1, total_therms: therms, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first

      #regional per_user average changes to internal users' upon update_all
      @region.update_data
      r1_avg_water = @region.avg_daily_water_consumed_per_user
      r1_avg_gas = @region.avg_daily_gas_consumed_per_user
      r1_avg_elec = @region.avg_daily_electricity_consumed_per_user

      #update changes water, elec and gas away from default
      expect(r1_avg_water.to_f.round(5)).to_not eq(@wavg.to_f.round(5))
      expect(r1_avg_gas.to_f.round(5)).to_not eq(@gavg.to_f.round(5))
      expect(r1_avg_elec.to_f.round(5)).to_not eq(@avg.to_f.round(5))
      #no carbon_ranking until default_ranks are set, which default to 0 until the front end pings (and update) the db
      expect(@region.carbon_ranking).to be(nil)
    end
  end
end
