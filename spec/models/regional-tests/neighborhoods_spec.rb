require 'rails_helper'

RSpec.describe 'neighborhood consumption averages' do
  before :each do
    avg = 12071.fdiv(30)
    @country = Country.create(name: "Country-land", avg_daily_electricity_consumed_per_capita: avg)
    @region = Region.create(name: "Region-land", country_id: @country.id)
    @city = City.create(name: "City", region_id: @region.id)
    @county = County.create(name: "County-within", region_id: @region.id)
    @neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: @city.id)
    @neighborhood2 = Neighborhood.create(name: "Other Neighborhood", city_id: @city.id)
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
    #same neighborhood
    @address2 = Address.create(address_line1: "245 Second Address", zipcode_id: @zip.id,
                              neighborhood_id: @neighborhood.id,
                              county_id: @county.id,
                              city_id: @city.id,
                              )
    #different neighborhood, same city
    @address3 = Address.create(address_line1: "678 Third Address", zipcode_id: @zip.id,
                              neighborhood_id: @neighborhood2.id,
                              county_id: @county.id,
                              city_id: @city.id,
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
  context "Electric Bills / 1 & 2 users affect (same) neighborhood" do
    it 'neighborhoods do not innately reflect their users averages' do
      user = User.first
      neighborhood = Neighborhood.first
      neighborhood2 = Neighborhood.second
      n1_avg = neighborhood.avg_daily_electricity_consumed_per_user
      n2_avg = neighborhood2.avg_daily_electricity_consumed_per_user
      u_avg = user.avg_daily_electricity_consumption
      expect(n1_avg).to eq(0)
      expect(n2_avg).to eq(0)
      expect(u_avg.nan?).to be true
    end
    it 'neighborhoods reflect single bill upon update' do
      user = User.first
      house = House.first
      neighborhood = Neighborhood.first
      expect(user.neighborhood).to eq(neighborhood)
      kwhs = 1400
      price = rand(1..100)
      ElectricBill.create(start_date: @start_date1, end_date: @end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      user = User.first
      n1_avg = neighborhood.avg_daily_electricity_consumed_per_user
      u_avg = user.avg_daily_electricity_consumption
      expect(n1_avg).to eq(0)
      expect(u_avg.to_f.round(2)).to eq(23.33)
      neighborhood.update_daily_avg_electricity_consumption
      n1_avg = neighborhood.avg_daily_electricity_consumed_per_user
      expect(n1_avg).to eq(u_avg)
    end
    it 'neighborhood avgs reflect accurate change upon new bill entry' do
      user = User.first
      house = House.first
      neighborhood = Neighborhood.first
      expect(user.houses.first).to eq(house)
      expect(user.neighborhood).to eq(neighborhood)
      kwhs = 1400
      kwhs2 = 2800
      price = rand(1..100)
      ElectricBill.create(start_date: @start_date1, end_date: @end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      neighborhood.update_daily_avg_electricity_consumption
      n1_avg1 = neighborhood.avg_daily_electricity_consumed_per_user
      expect(n1_avg1.to_f.round(2)).to eq(23.33)
      #-- add second bill --#
      ElectricBill.create(start_date: @start_date2, end_date: @end_date2, total_kwhs: kwhs2, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      user = User.first
      u_avg = user.avg_daily_electricity_consumption
      n1_new_avg = neighborhood.avg_daily_electricity_consumed_per_user
      expect(u_avg.to_f.round(2)).to eq(35.0)
      expect(n1_new_avg.to_f.round(2)).to eq(23.33)
      expect(n1_new_avg).to eq(n1_avg1)
      #user consumed twice as much second month
      expect(kwhs * 2).to eq(kwhs2)
      #--- updates neighborhood ---- #
      neighborhood = Neighborhood.first
      neighborhood.update_daily_avg_electricity_consumption
      n1_avg2 = neighborhood.avg_daily_electricity_consumed_per_user
      #new average is twice as
      expect(n1_avg2).to eq(u_avg)
    end
    it 'neighborhood avgs reflect accurate mean between two users' do
      #add users to separate houses within same neighborhood
      #check same neighborhood
      User.first.clear_totals
      expect(User.first.neighborhood).to eq(User.second.neighborhood)
      expect(User.second.neighborhood).to_not eq(User.third.neighborhood)
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
      #--- updates neighborhood ---- #
      neighborhood = User.first.neighborhood
      neighborhood.update_daily_avg_electricity_consumption
      n1_avg = neighborhood.avg_daily_electricity_consumed_per_user
      #first average is twice as large as first persons average
      expect(n1_avg.to_f.round(1)).to eq(35.0)
    end
  end
  context "Water Bills / 1 & 2 users affect (same) neighborhood" do
    it 'neighborhoods do not innately reflect their users averages' do
      user = User.first
      neighborhood = Neighborhood.first
      neighborhood2 = Neighborhood.second
      n1_avg = neighborhood.avg_daily_electricity_consumed_per_user
      n2_avg = neighborhood2.avg_daily_electricity_consumed_per_user
      u_avg = user.avg_daily_electricity_consumption
      expect(n1_avg).to eq(0)
      expect(n2_avg).to eq(0)
      expect(u_avg.nan?).to be true
    end
    it 'neighborhoods reflect single bill upon update' do
      user = User.first
      house = House.first
      neighborhood = Neighborhood.first
      expect(user.neighborhood).to eq(neighborhood)
      kwhs = 1400
      price = rand(1..100)
      ElectricBill.create(start_date: @start_date1, end_date: @end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      user = User.first
      n1_avg = neighborhood.avg_daily_electricity_consumed_per_user
      u_avg = user.avg_daily_electricity_consumption
      expect(n1_avg).to eq(0)
      expect(u_avg.to_f.round(2)).to eq(23.33)
      neighborhood.update_daily_avg_electricity_consumption
      n1_avg = neighborhood.avg_daily_electricity_consumed_per_user
      expect(n1_avg).to eq(u_avg)
    end
    it 'neighborhood avgs reflect accurate change upon new bill entry' do
      user = User.first
      house = House.first
      neighborhood = Neighborhood.first
      expect(user.houses.first).to eq(house)
      expect(user.neighborhood).to eq(neighborhood)
      kwhs = 1400
      kwhs2 = 2800
      price = rand(1..100)
      ElectricBill.create(start_date: @start_date1, end_date: @end_date1, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      neighborhood.update_daily_avg_electricity_consumption
      n1_avg1 = neighborhood.avg_daily_electricity_consumed_per_user
      expect(n1_avg1.to_f.round(2)).to eq(23.33)
      #-- add second bill --#
      ElectricBill.create(start_date: @start_date2, end_date: @end_date2, total_kwhs: kwhs2, price: price, house_id: house.id, no_residents: 2, user_id: user.id)
      user = User.first
      u_avg = user.avg_daily_electricity_consumption
      n1_new_avg = neighborhood.avg_daily_electricity_consumed_per_user
      expect(u_avg.to_f.round(2)).to eq(35.0)
      expect(n1_new_avg.to_f.round(2)).to eq(23.33)
      expect(n1_new_avg).to eq(n1_avg1)
      #user consumed twice as much second month
      expect(kwhs * 2).to eq(kwhs2)
      #--- updates neighborhood ---- #
      neighborhood = Neighborhood.first
      neighborhood.update_daily_avg_electricity_consumption
      n1_avg2 = neighborhood.avg_daily_electricity_consumed_per_user
      #new average is twice as
      expect(n1_avg2).to eq(u_avg)
    end
    it 'neighborhood avgs reflect accurate mean between two users' do
      #add users to separate houses within same neighborhood
      #check same neighborhood
      User.first.clear_totals
      expect(User.first.neighborhood).to eq(User.second.neighborhood)
      expect(User.second.neighborhood).to_not eq(User.third.neighborhood)
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
      #--- updates neighborhood ---- #
      neighborhood = User.first.neighborhood
      neighborhood.update_daily_avg_electricity_consumption
      n1_avg = neighborhood.avg_daily_electricity_consumed_per_user
      #first average is twice as large as first persons average
      expect(n1_avg.to_f.round(1)).to eq(35.0)
    end
  end
  xcontext "Heat Bills / 1 & 2 users affect (same) neighborhood" do

  end
  context "two people within area affects entire score" do

  end
end
