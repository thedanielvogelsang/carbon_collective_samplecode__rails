require 'rails_helper'

RSpec.describe 'County consumption averages' do
  before :each do
    avg = 12071.fdiv(30)
    wavg = 409466.6
    gavg = 10.88
    @country = Country.create(name: "Country-land", avg_daily_electricity_consumed_per_capita: avg, avg_daily_water_consumed_per_capita: wavg, avg_daily_gas_consumed_per_capita: gavg)
    @region = Region.create(name: "Region-land", country_id: @country.id)
    @city = City.create(name: "City", region_id: @region.id)
    @city2 = City.create(name: "City2", region_id: @region.id)
    @county = County.create(name: "County-within", region_id: @region.id)
    @county2 = County.create(name: "County-without", region_id: @region.id)
    @neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: @city.id)
    @neighborhood2 = Neighborhood.create(name: "My Second Neighborhood", city_id: @city.id)
    @neighborhood3 = Neighborhood.create(name: "Other Neighborhood", city_id: @city2.id)
    @zip = Zipcode.create(zipcode: 80291)
    @start_date1 = DateTime.now - 30
    @end_date1 = DateTime.now
    @start_date2 = DateTime.now - 61
    @end_date2 = DateTime.now - 31
    @address1 = Address.create(address_line1: "123 My Address", zipcode_id: @zip.id,
                              neighborhood_id: @neighborhood.id,
                              county_id: @county.id,
                              city_id: @city.id,
                              )
    #same county/city, different neighborhood
    @address2 = Address.create(address_line1: "245 Second Address", zipcode_id: @zip.id,
                              neighborhood_id: @neighborhood2.id,
                              county_id: @county.id,
                              city_id: @city.id,
                              )
    #different county, city, and neighborhood, same region/country
    @address3 = Address.create(address_line1: "678 Third Address", zipcode_id: @zip.id,
                              neighborhood_id: @neighborhood3.id,
                              county_id: @county2.id,
                              city_id: @city2.id,
                              )
    #single user
    user = User.create(first: 'D', last: "Simpson", email: "d.simpson@gmail.com",
                        password: 'password', generation: 1)
    house = House.create(address_id: @address1.id, no_residents: 1, total_sq_ft: 3000)
    user.houses << house

    user2 = User.create(first: 'M', last: "Johnson", email: "m.johnson@gmail.com",
                        password: 'password', generation: 1)

    house = House.create(address_id: @address2.id, no_residents: 1, total_sq_ft: 3000)
    user2.houses << house

    user3 = User.create(first: 'J', last: "Geirgio", email: "j.geirgio@gmail.com",
                        password: 'password', generation: 1)

    house = House.create(address_id: @address3.id, no_residents: 1, total_sq_ft: 3000)
    user3.houses << house
  end
  context "Electric Bills / 1 & 2 users affect (same) county" do
    it 'counties do not innately reflect their users averages' do
      user = User.first
      county = County.first
      county2 = County.second
      c1_avg = county.avg_daily_electricity_consumed_per_user
      c2_avg = county2.avg_daily_electricity_consumed_per_user
      u_avg = user.avg_daily_electricity_consumption
      expect(c1_avg).to eq(0)
      expect(c2_avg).to eq(0)
      expect(u_avg.nan?).to be true
    end
    it 'cities reflect single bill upon update' do
      user = User.first
      house = House.first
      county = County.first
      expect(user.county).to eq(county)
      kwhs = 1400
      price = rand(1..100)
      ElectricBill.create(start_date: @start_date1, end_date: @end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      user = User.first
      c1_avg = county.avg_daily_electricity_consumed_per_user
      u_avg = user.avg_daily_electricity_consumption
      expect(c1_avg).to eq(0)
      expect(u_avg.to_f.round(2)).to eq(23.33)
      county.update_daily_avg_electricity_consumption
      c1_avg = county.avg_daily_electricity_consumed_per_user
      expect(c1_avg).to eq(u_avg)
    end
    it 'county avgs reflect accurate change upon new bill entry' do
      user = User.first
      house = House.first
      county = County.first
      expect(user.houses.first).to eq(house)
      expect(user.county).to eq(county)
      kwhs = 1400
      kwhs2 = 2800
      price = rand(1..100)
      ElectricBill.create(start_date: @start_date1, end_date: @end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      county.update_daily_avg_electricity_consumption
      c1_avg1 = county.avg_daily_electricity_consumed_per_user
      expect(c1_avg1.to_f.round(2)).to eq(23.33)
      #-- add second bill --#
      ElectricBill.create(start_date: @start_date2, end_date: @end_date2, total_kwhs: kwhs2, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      user = User.first
      u_avg = user.avg_daily_electricity_consumption
      c1_new_avg = county.avg_daily_electricity_consumed_per_user
      expect(u_avg.to_f.round(2)).to eq(35.0)
      expect(c1_new_avg.to_f.round(2)).to eq(23.33)
      expect(c1_new_avg).to eq(c1_avg1)
      #user consumed twice as much second month
      expect(kwhs * 2).to eq(kwhs2)
      #--- updates county ---- #
      county = County.first
      county.update_daily_avg_electricity_consumption
      c1_avg2 = county.avg_daily_electricity_consumed_per_user
      #new average is twice as
      expect(c1_avg2).to eq(u_avg)
    end
    it 'county avgs reflect accurate mean between two users' do
      #add users to separate houses within same county
      #check same county
      User.first.clear_totals
      expect(User.first.county).to eq(User.second.county)
      expect(User.second.county).to_not eq(User.third.county)
      #-- add bill to second house--#
      kwhs = 1400
      price = rand(1..100)
      bill = ElectricBill.create(start_date: @start_date1, end_date: @end_date1, total_kwhs: kwhs, price: price, house_id: House.first.id, no_residents: 2, user_id: User.first.id)
      #-- add bill to second house--#
      kwhs2 = 2800
      price = rand(1..100)
      bill = ElectricBill.create(start_date: @start_date2, end_date: @end_date2, total_kwhs: kwhs2, price: price, house_id: House.second.id, no_residents: 2, user_id: User.second.id)
      user = User.first
      user2 = User.second
      u_avg = user.avg_daily_electricity_consumption
      u2_avg = user2.avg_daily_electricity_consumption
      #first average is twice as large as first persons average
      expect(u_avg.to_f.round(1)).to eq(23.3)
      expect(u2_avg.to_f.round(1)).to eq(46.7)
      #--- updates county ---- #
      county = User.first.county
      county.update_daily_avg_electricity_consumption
      c1_avg = county.avg_daily_electricity_consumed_per_user
      #first average is twice as large as first persons average
      expect(c1_avg.to_f.round(1)).to eq(35.0)
    end
  end
  context "Water Bills / 1 & 2 users affect (same) county" do
    it 'countys do not innately reflect their users averages' do
      user = User.first
      county = County.first
      county2 = County.second
      c1_avg = county.avg_daily_water_consumed_per_user
      c2_avg = county2.avg_daily_water_consumed_per_user
      u_avg = user.avg_daily_water_consumption
      expect(c1_avg).to eq(0)
      expect(c2_avg).to eq(0)
      expect(u_avg.nan?).to be true
    end
    it 'countys reflect single bill upon update' do
      user = User.first
      house = House.first
      county = County.first
      expect(user.county).to eq(county)
      gallons = 14000
      price = rand(1..100)
      WaterBill.create(start_date: @start_date1, end_date: @end_date1, total_gallons: gallons, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      user = User.first
      c1_avg = county.avg_daily_water_consumed_per_user
      u_avg = user.avg_daily_water_consumption
      expect(c1_avg).to eq(0)
      expect(u_avg.to_f.round(2)).to eq(233.33)
      county.update_daily_avg_water_consumption
      c1_avg = county.avg_daily_water_consumed_per_user
      expect(c1_avg).to eq(u_avg)
    end
    it 'county avgs reflect accurate change upon new bill entry' do
      user = User.first
      house = House.first
      county = County.first
      expect(user.houses.first).to eq(house)
      expect(user.county).to eq(county)
      gallons = 14000
      gallons2 = 28000
      price = rand(1..100)
      WaterBill.create(start_date: @start_date1, end_date: @end_date1, total_gallons: gallons, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      county.update_daily_avg_water_consumption
      c1_avg1 = county.avg_daily_water_consumed_per_user
      expect(c1_avg1.to_f.round(2)).to eq(233.33)
      #-- add second bill --#
      WaterBill.create(start_date: @start_date2, end_date: @end_date2, total_gallons: gallons2, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      user = User.first
      u_avg = user.avg_daily_water_consumption
      c1_new_avg = county.avg_daily_water_consumed_per_user
      expect(u_avg.to_f.round(2)).to eq(350.0)
      expect(c1_new_avg.to_f.round(2)).to eq(233.33)
      expect(c1_new_avg).to eq(c1_avg1)
      #user consumed twice as much second month
      expect(gallons * 2).to eq(gallons2)
      #--- updates county ---- #
      county = County.first
      county.update_daily_avg_water_consumption
      c1_avg2 = county.avg_daily_water_consumed_per_user
      #new average is twice as
      expect(c1_avg2).to eq(u_avg)
    end
    it 'county avgs reflect accurate mean between two users' do
      #add users to separate houses within same county
      #check same county
      User.first.clear_totals
      expect(User.first.county).to eq(User.second.county)
      expect(User.second.county).to_not eq(User.third.county)
      #-- add bill to second house--#
      gallons = 14000
      price = rand(1..100)
      WaterBill.create(start_date: @start_date1, end_date: @end_date1, total_gallons: gallons, price: price, house_id: House.first.id, no_residents: 2, user_id: User.first.id)
      #-- add bill to second house--#
      gallons2 = 28000
      price = rand(1..100)
      WaterBill.create(start_date: @start_date2, end_date: @end_date2, total_gallons: gallons2, price: price, house_id: House.second.id, no_residents: 2, user_id: User.second.id)
      user = User.first
      user2 = User.second
      u_avg = user.avg_daily_water_consumption
      u2_avg = user2.avg_daily_water_consumption
      #first average is twice as large as first persons average
      expect(u_avg.to_f.round(1)).to eq(233.3)
      expect(u2_avg.to_f.round(1)).to eq(466.7)
      #--- updates county ---- #
      county = User.first.county
      county.update_daily_avg_water_consumption
      c1_avg = county.avg_daily_water_consumed_per_user
      #first average is twice as large as first persons average
      expect(c1_avg.to_f.round(1)).to eq(350.0)
    end
  end
  context "Heat Bills / 1 & 2 users affect (same) county" do
    it 'countys do not innately reflect their users averages' do
      user = User.first
      county = County.first
      county2 = County.second
      c1_avg = county.avg_daily_gas_consumed_per_user
      c2_avg = county2.avg_daily_gas_consumed_per_user
      u_avg = user.avg_daily_gas_consumption
      expect(c1_avg).to eq(0)
      expect(c2_avg).to eq(0)
      expect(u_avg.nan?).to be true
    end
    it 'countys reflect single bill upon update' do
      user = User.first
      house = House.first
      county = County.first
      expect(user.county).to eq(county)
      therms = 300
      price = rand(1..100)
      HeatBill.create(start_date: @start_date1, end_date: @end_date1, total_therms: therms, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      user = User.first
      c1_avg = county.avg_daily_gas_consumed_per_user
      u_avg = user.avg_daily_gas_consumption
      expect(c1_avg).to eq(0)
      expect(u_avg.to_f.round(2)).to eq(5.0)
      county.update_daily_avg_gas_consumption
      c1_avg = county.avg_daily_gas_consumed_per_user
      expect(c1_avg).to eq(u_avg)
    end
    it 'county avgs reflect accurate change upon new bill entry' do
      user = User.first
      house = House.first
      county = County.first
      expect(user.houses.first).to eq(house)
      expect(user.county).to eq(county)
      therms = 300
      therms2 = 600
      price = rand(1..100)
      HeatBill.create(start_date: @start_date1, end_date: @end_date1, total_therms: therms, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      county.update_daily_avg_gas_consumption
      c1_avg1 = county.avg_daily_gas_consumed_per_user
      expect(c1_avg1.to_f.round(2)).to eq(5.0)
      #-- add second bill --#
      HeatBill.create(start_date: @start_date2, end_date: @end_date2, total_therms: therms2, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      user = User.first
      u_avg = user.avg_daily_gas_consumption
      c1_new_avg = county.avg_daily_gas_consumed_per_user
      expect(u_avg.to_f.round(2)).to eq(7.50)
      expect(c1_new_avg.to_f.round(2)).to eq(5.0)
      expect(c1_new_avg).to eq(c1_avg1)
      #user consumed twice as much second month
      expect(therms * 2).to eq(therms2)
      #--- updates county ---- #
      county = County.first
      county.update_daily_avg_gas_consumption
      c1_avg2 = county.avg_daily_gas_consumed_per_user
      #new average is twice as
      expect(c1_avg2).to eq(u_avg)
    end
    it 'county avgs reflect accurate mean between two users' do
      #add users to separate houses within same county
      #check same county
      User.first.clear_totals
      expect(User.first.county).to eq(User.second.county)
      expect(User.second.county).to_not eq(User.third.county)
      #-- add bill to second house--#
      therms = 300
      price = rand(1..100)
      HeatBill.create(start_date: @start_date1, end_date: @end_date1, total_therms: therms, price: price, house_id: House.first.id, no_residents: 2, user_id: User.first.id)
      #-- add bill to second house--#
      therms2 = 600
      price = rand(1..100)
      HeatBill.create(start_date: @start_date2, end_date: @end_date2, total_therms: therms2, price: price, house_id: House.second.id, no_residents: 2, user_id: User.second.id)
      user = User.first
      user2 = User.second
      u_avg = user.avg_daily_gas_consumption
      u2_avg = user2.avg_daily_gas_consumption
      #first average is twice as large as first persons average
      expect(u_avg.to_f.round(1)).to eq(5.0)
      expect(u2_avg.to_f.round(1)).to eq(10.0)
      #--- updates county ---- #
      county = User.first.county
      county.update_daily_avg_gas_consumption
      c1_avg = county.avg_daily_gas_consumed_per_user
      #first average is twice as large as first persons average
      expect(c1_avg.to_f.round(1)).to eq(7.50)
    end
  end
  xcontext "two people within area affects entire score" do
  end
end
