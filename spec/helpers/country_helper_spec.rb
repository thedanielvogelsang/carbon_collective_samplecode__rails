require 'rails_helper'

RSpec.describe CountryHelper, type: :helper do
  before :each do
    @avg = 12071.fdiv(30)
    @wavg = 409466.6
    @gavg = 10.88
    @country = Country.create(name: "Country-land", avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
  end
  context 'country with no users' do
    it 'can access all helper methods accurately' do
      expect(@country.out_of).to eq(1)
      expect(Country.count).to eq(1)
      Country.create(name: "Country Two")
      expect(@country.out_of).to eq(2)
      expect(@country.set_default_ranks).to be_valid
    end
    it 'does not set ranks automatically' do
      country = Country.new(name: "New country", avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
      expect(country.water_ranking).to eq(nil)
      expect(country.electricity_ranking).to eq(nil)
      expect(country.gas_ranking).to eq(nil)
      expect(country.carbon_ranking).to eq(nil)

      country.save
      expect(country.water_ranking).to eq(nil)
      expect(country.electricity_ranking).to eq(nil)
      expect(country.gas_ranking).to eq(nil)
      expect(country.carbon_ranking).to eq(nil)

      #set defaults
      country.set_default_ranks
      country = Country.last

      expect(country.water_ranking).to be_kind_of(WaterRanking)
      expect(country.electricity_ranking).to be_kind_of(ElectricityRanking)
      expect(country.gas_ranking).to be_kind_of(GasRanking)
      expect(country.carbon_ranking).to be_kind_of(CarbonRanking)
    end
    it 'sets ranks with nil' do
      country = Country.create(name: "New Country", avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)

      country.set_default_ranks
      country = Country.last
      expect(country.water_ranking.rank).to eq(nil)
      expect(country.electricity_ranking.rank).to eq(nil)
      expect(country.gas_ranking.rank).to eq(nil)
      expect(country.carbon_ranking.rank).to eq(nil)
    end
  end
  context 'country with users' do
    it 'updates totals accurately via individual method (electricity)' do
      @region = Region.create(name: "Region-land", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
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
      user.houses << house

      expect(@country.avg_daily_electricity_consumed_per_capita.to_f.round(6)).to eq(@avg.round(6))
      expect(@country.avg_daily_electricity_consumed_per_user.to_f.round(6)).to eq(@avg.round(6))

      expect(user.country).to eq(@country)
      kwhs = 1400
      price = rand(1..100)
      ElectricBill.create(start_date: start_date1, end_date: end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      c1_avg = @country.avg_daily_electricity_consumed_per_user
      u_avg = user.avg_daily_electricity_consumption

      #regional per_user average is same as per_capita by default
      expect(c1_avg.to_f.round(5)).to eq(@avg.to_f.round(5))
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(c1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))
      @country.update_daily_avg_electricity_consumption

      #regional per_user average changes to internal users' upon update
      c1_avg = @country.avg_daily_electricity_consumed_per_user
      expect(c1_avg.to_f.round(5)).to_not eq(@avg.to_f.round(5))
      #area average == user average
      expect(c1_avg).to eq(u_avg)

      #regional water and gas consumption scores left unaffected
      w_consumption = @country.avg_daily_water_consumed_per_user
      g_consumption = @country.avg_daily_gas_consumed_per_user
      expect(w_consumption.to_f.round(3)).to eq(@wavg.to_f.round(3))
      expect(g_consumption.to_f.round(3)).to eq(@gavg.to_f.round(3))
    end
    it 'updates totals accurately via individual method (water)' do
      @region = Region.create(name: "Region-land", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
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
      user.houses << house

      expect(@country.avg_daily_water_consumed_per_capita.to_f.round(6)).to eq(@wavg.round(6))
      expect(@country.avg_daily_water_consumed_per_user.to_f.round(6)).to eq(@wavg.round(6))

      expect(user.country).to eq(@country)
      gals = 1400
      price = rand(1..100)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gals, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      r1_avg = @country.avg_daily_water_consumed_per_user
      u_avg = user.avg_daily_water_consumption

      #regional per_user average is same as per_capita by default
      expect(r1_avg.to_f.round(5)).to eq(@wavg.to_f.round(5))
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(r1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #regional per_user average changes to internal users' upon update
      @country.update_daily_avg_water_consumption
      r1_avg = @country.avg_daily_water_consumed_per_user
      expect(r1_avg.to_f.round(5)).to_not eq(@wavg.to_f.round(5))
      #area average == user average
      expect(r1_avg).to eq(u_avg)

      #regional water and gas consumption scores left unaffected
      g_consumption = @country.avg_daily_gas_consumed_per_user
      e_consumption = @country.avg_daily_electricity_consumed_per_user
      expect(g_consumption.to_f.round(3)).to eq(@gavg.to_f.round(3))
      expect(e_consumption.to_f.round(3)).to eq(@avg.to_f.round(3))
    end
    it 'updates totals accurately via individual method (gas)' do
      @region = Region.create(name: "Region-land", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
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
      user.houses << house

      expect(@country.avg_daily_gas_consumed_per_capita.to_f.round(6)).to eq(@gavg.round(6))
      expect(@country.avg_daily_gas_consumed_per_user.to_f.round(6)).to eq(@gavg.round(6))

      expect(user.country).to eq(@country)
      therms = 1400
      price = rand(1..100)
      HeatBill.create(start_date: start_date1, end_date: end_date1, total_therms: therms, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      c1_avg = @country.avg_daily_gas_consumed_per_user
      u_avg = user.avg_daily_gas_consumption

      #regional per_user average is same as per_capita by default
      expect(c1_avg.to_f.round(5)).to eq(@gavg.to_f.round(5))
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(c1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #regional per_user average changes to internal users' upon update
      @country.update_daily_avg_gas_consumption
      c1_avg = @country.avg_daily_gas_consumed_per_user
      expect(c1_avg.to_f.round(5)).to_not eq(@avg.to_f.round(5))
      #area average == user average
      expect(c1_avg).to eq(u_avg)

      #regional water and gas consumption scores left unaffected
      w_consumption = @country.avg_daily_water_consumed_per_user
      e_consumption = @country.avg_daily_electricity_consumed_per_user
      expect(w_consumption.to_f.round(3)).to eq(@wavg.to_f.round(3))
      expect(e_consumption.to_f.round(3)).to eq(@avg.to_f.round(3))
    end
    it 'update all zeros data however and erases per_capita/per_user link' do
      @region = Region.create(name: "Region-land", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
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
      user.houses << house

      expect(@country.avg_daily_water_consumed_per_capita.to_f.round(6)).to eq(@wavg.round(6))
      expect(@country.avg_daily_water_consumed_per_user.to_f.round(6)).to eq(@wavg.round(6))

      expect(user.country).to eq(@country)
      gals = 1400
      price = rand(1..100)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gals, price: price, house_id: house.id, no_residents: 2, user_id: user.id)

      user = User.first
      r1_avg = @country.avg_daily_water_consumed_per_user
      u_avg = user.avg_daily_water_consumption

      #regional per_user average is same as per_capita by default
      expect(r1_avg.to_f.round(5)).to eq(@wavg.to_f.round(5))
      expect(u_avg.to_f.round(2)).to eq(23.33)
      expect(r1_avg.to_f.round(2)).to_not eq(u_avg.to_f.round(2))

      #regional per_user average changes to internal users' upon update_all
      @country.update_data
      r1_avg = @country.avg_daily_water_consumed_per_user
      expect(r1_avg.to_f.round(5)).to_not eq(@wavg.to_f.round(5))
      #area average == user average
      expect(r1_avg).to eq(u_avg)

      #regional water and gas consumption scores changeo to ZEROS
      g_consumption = @country.avg_daily_gas_consumed_per_user
      e_consumption = @country.avg_daily_electricity_consumed_per_user
      expect(g_consumption.to_f.round(3)).to eq(0.0)
      expect(e_consumption.to_f.round(3)).to eq(0.0)
    end
  end
end
