require 'rails_helper'

@start_date1 = DateTime.now - 30
@end_date1 = DateTime.now
@start_date2 = DateTime.now - 61
@end_date2 = DateTime.now - 31

RSpec.describe HouseHelper, type: :helper do
  before :each do
    @avg = 12071.fdiv(30)
    @wavg = 409466.6
    @gavg = 10.88
    @country = Country.create(name: "Country-land", avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
    @region = Region.create(name: "Region-land", country_id: @country.id, avg_daily_electricity_consumed_per_capita: @avg, avg_daily_water_consumed_per_capita: @wavg, avg_daily_gas_consumed_per_capita: @gavg)
    @city = City.create(name: "City", region_id: @region.id)
    @county = County.create(name: "County-within", region_id: @region.id)
    @neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: @city.id)
    zip = Zipcode.create(zipcode: 80291)

    address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                              neighborhood_id: @neighborhood.id,
                              county_id: @county.id,
                              city_id: @city.id,
                              )
    @user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                        password: 'password', generation: 1)
    @house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
    UserHouse.create(house_id: @house.id, user_id: @user.id, move_in_date: DateTime.now - 90)
    @house = House.first
    @house.no_residents = 1
    @house.save
  end
  context 'house with no bills' do
    it 'can access all helper methods accurately' do
      #consumption
      expect(@house.average_daily_electricity_consumption_per_user).to eq(0.0)
      expect(@house.average_daily_water_consumption_per_user).to eq(0.0)
      expect(@house.average_daily_gas_consumption_per_user).to eq(0.0)
      expect(@house.average_daily_carbon_consumption_per_user).to eq(0.0)
      expect(@house.average_total_electricity_consumption_per_resident).to eq(0.0)
      expect(@house.average_daily_electricity_consumption_per_resident).to eq(0.0)
      expect(@house.average_total_water_consumption_per_resident).to eq(0.0)
      expect(@house.average_daily_water_consumption_per_resident).to eq(0.0)
      expect(@house.average_total_gas_consumption_per_resident).to eq(0.0)
      expect(@house.average_daily_gas_consumption_per_resident).to eq(0.0)
      expect(@house.average_total_carbon_consumption_per_resident).to eq(0.0)
      #savings
      expect(@house.average_total_electricity_saved_per_resident).to eq(0.0)
      expect(@house.average_total_water_saved_per_resident).to eq(0.0)
      expect(@house.average_total_gas_saved_per_resident).to eq(0.0)
      expect(@house.total_carbon_savings_to_date).to eq(0.0)
      expect(@house.average_total_carbon_saved_per_resident).to eq(0.0)

      #house totals/figures
      expect(@house.total_spent).to eq(0.0)
      expect(@house.total_days_recorded).to eq(0)
      expect(@house.total_electricity_consumption_to_date).to eq(0.0)
      expect(@house.total_electricity_savings_to_date).to eq(0.0)
      expect(@house.total_electricity_saved).to eq(0.0)
      expect(@house.total_water_consumption_to_date).to eq(0.0)
      expect(@house.total_water_savings_to_date).to eq(0.0)
      expect(@house.total_water_saved).to eq(0.0)
      expect(@house.total_gas_consumption_to_date).to eq(0.0)
      expect(@house.total_gas_savings_to_date).to eq(0.0)
      expect(@house.total_gas_saved).to eq(0.0)
      expect(@house.total_carbon_consumption_to_date).to eq(0.0)
      expect(@house.total_carbon_savings_to_date).to eq(0.0)
      expect(@house.total_carbon_saved).to eq(0.0)
    end
    it 'calculates user order accurately for ranking if users have history' do
        daniel = User.create(first: "D", last: "John", email: "djohn@gmail.com", password: "password", generation: 1)
        # carrie = User.create(first: "C", last: "Krask", email: "ckrask@gmail.com", password: "password", generation: 1)
        rachitha = @user

        daniel.houses << @house

        expect(@house.users.include?(daniel)).to be(true)
        expect(@house.users.include?(rachitha)).to be(true)

        daniel.total_kwhs_logged = 1000
        daniel.total_electricitybill_days_logged = 30
        daniel.total_therms_logged = 10
        daniel.total_heatbill_days_logged = 30
        daniel.save

        rachitha.total_gallons_logged = 10000
        rachitha.total_waterbill_days_logged = 30
        rachitha.save

        #rachita has no electricity kwhs logged, therefore is first in array (sorted asc)
        expect(@house.users.sort{|u| u.avg_daily_electricity_consumption}.first).to eq(rachitha)
        #rachita has no gas therms logged, therefore is first in array (sorted asc)
        expect(@house.users.sort{|u| u.avg_daily_gas_consumption}.first).to eq(rachitha)
        #daniel has no water gallons logged, therefore is first in array (sorted asc)
        expect(@house.users.sort{|u| u.avg_daily_water_consumption}.first).to eq(daniel)
        #rachita has no electricity kwhs or gas therms logged, therefore is first in array (sorted asc)
        expect(@house.users.sort{|u| u.avg_daily_carbon_consumption}.first).to eq(rachitha)

        expect(rachitha.avg_daily_carbon_consumption).to eq(0.0)
        expect(rachitha.avg_daily_electricity_consumption).to eq(0.0)
        expect(rachitha.avg_daily_gas_consumption).to eq(0.0)
        expect(rachitha.avg_daily_water_consumption.to_f.round(2)).to eq(333.33)

        d_avg_elect = daniel.avg_daily_electricity_consumption
        d_avg_gas = daniel.avg_daily_gas_consumption
        expect(d_avg_elect.to_f.round(2)).to eq(33.33)
        expect(d_avg_gas.to_f.round(2)).to eq(0.33)

        carbon_avg = @house.combine_average_use(d_avg_elect, d_avg_gas).to_f.round(2)

        expect(daniel.avg_daily_carbon_consumption.to_f.round(2)).to eq(44.76)
        expect(daniel.avg_daily_carbon_consumption.to_f.round(2)).to eq(carbon_avg)
        expect(daniel.avg_daily_water_consumption).to eq(0.0)
    end
  end
  context 'house with users' do
    it 'calculates all household stats accurately' do
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      kwhs = 1400
      price = rand(1..100)

        expect(@house.total_spent).to eq(0.0)

      #add bills
      ElectricBill.create(start_date: start_date1, end_date: end_date1, total_kwhs: kwhs, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: kwhs, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)
      HeatBill.create(start_date: start_date1, end_date: end_date1, total_therms: kwhs, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)

        expect(@house.bills.count).to eq(1)
        expect(@house.wbills.count).to eq(1)
        expect(@house.gbills.count).to eq(1)

        expect(@house.total_spent > 0).to be true
        expect(@house.total_days_recorded).to eq(90)

        expect(@house.total_electricity_consumption_to_date).to eq(1400)
        expect(@house.total_water_consumption_to_date).to eq(1400)
        expect(@house.total_gas_consumption_to_date).to eq(1400)
        expect(@house.total_carbon_consumption_to_date.to_f.round(2)).to eq(18624.38)
    end
    it 'updates totals accurately via individual method (electricity)' do
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31

        expect(@house.total_spent).to eq(0.0)
        expect(@house.bills).to be_empty
        expect(@house.wbills).to be_empty
        expect(@house.gbills).to be_empty
      #add bill
      kwhs = 1400
      price = rand(1..100)
      ElectricBill.create(start_date: start_date1, end_date: end_date1, total_kwhs: kwhs, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)

      #regional per_user average is same as user immediately
      user = @house.users.first
        expect(@house.users.count).to eq(1)
        expect(@house.bills.count).to eq(1)
        expect(user.avg_daily_electricity_consumption.to_f.round(2)).to eq(23.33)
        expect(@house.average_daily_electricity_consumption_per_user.to_f.round(2)).to eq(23.33)

      #regional per_user average changes to internal users' upon update
      kwhs = 2800
      price = rand(1..100)
      ElectricBill.create(start_date: start_date2, end_date: end_date2, total_kwhs: kwhs, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)
      user = User.find(@user.id)
      house = House.find(@house.id)
        expect(house.bills.count).to eq(2)
        expect(user.avg_daily_electricity_consumption.to_f.round(2)).to eq(35.00)
        expect(house.average_daily_electricity_consumption_per_user.to_f.round(2)).to eq(35.00)

      #regional water and gas consumption scores left unaffected
        expect(house.wbills.count).to eq(0)
        expect(house.gbills.count).to eq(0)

        expect(user.avg_daily_water_consumption).to eq(0.0)
        expect(house.average_daily_water_consumption_per_user).to eq(0.0)
        expect(user.avg_daily_gas_consumption).to eq(0.0)
        expect(house.average_daily_gas_consumption_per_user).to eq(0.0)
    end
    it 'updates totals accurately via individual method (water)' do
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31

        expect(@house.total_spent).to eq(0.0)
        expect(@house.bills).to be_empty
        expect(@house.wbills).to be_empty
        expect(@house.gbills).to be_empty

      #add bill
      gallons = 1400
      price = rand(1..100)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: gallons, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)

      #regional per_user average is same as user immediately
      user = @house.users.first
        expect(@house.users.count).to eq(1)
        expect(@house.wbills.count).to eq(1)
        expect(user.avg_daily_water_consumption.to_f.round(2)).to eq(23.33)
        expect(@house.average_daily_water_consumption_per_user.to_f.round(2)).to eq(23.33)

      #regional per_user average changes to internal users' upon update
      gallons = 2800
      price = rand(1..100)
      WaterBill.create(start_date: start_date2, end_date: end_date2, total_gallons: gallons, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)
      user = User.find(@user.id)
      house = House.find(@house.id)
        expect(house.wbills.count).to eq(2)
        expect(user.avg_daily_water_consumption.to_f.round(2)).to eq(35.00)
        expect(house.average_daily_water_consumption_per_user.to_f.round(2)).to eq(35.00)

      #regional electricity and gas consumption scores left unaffected
        expect(house.bills.count).to eq(0)
        expect(house.gbills.count).to eq(0)

        expect(user.avg_daily_electricity_consumption).to eq(0.0)
        expect(house.average_daily_electricity_consumption_per_user).to eq(0.0)
        expect(user.avg_daily_gas_consumption).to eq(0.0)
        expect(house.average_daily_gas_consumption_per_user).to eq(0.0)
          #carbon
          expect(user.avg_daily_carbon_consumption).to eq(0.0)
          expect(house.average_daily_carbon_consumption_per_user).to eq(0.0)
    end
    it 'updates totals accurately via individual method (gas)' do
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31

        expect(@house.total_spent).to eq(0.0)
        expect(@house.bills).to be_empty
        expect(@house.wbills).to be_empty
        expect(@house.gbills).to be_empty

      therms = 1400
      price = rand(1..100)
      HeatBill.create(start_date: start_date1, end_date: end_date1, total_therms: therms, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)

      #regional per_user average is same as user immediately
      user = @house.users.first
        expect(@house.users.count).to eq(1)
        expect(@house.gbills.count).to eq(1)
        expect(user.avg_daily_gas_consumption.to_f.round(2)).to eq(23.33)
        expect(@house.average_daily_gas_consumption_per_user.to_f.round(2)).to eq(23.33)

      #regional per_user average changes to internal users' upon update
      therms = 2800
      price = rand(1..100)
      HeatBill.create(start_date: start_date2, end_date: end_date2, total_therms: therms, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)
      user = User.find(@user.id)
      house = House.find(@house.id)
        expect(house.gbills.count).to eq(2)
        expect(user.avg_daily_gas_consumption.to_f.round(2)).to eq(35.00)
        expect(house.average_daily_gas_consumption_per_user.to_f.round(2)).to eq(35.00)

      #regional water and electricity consumption scores left unaffected
        expect(house.bills.count).to eq(0)
        expect(house.wbills.count).to eq(0)

        expect(user.avg_daily_water_consumption).to eq(0.0)
        expect(house.average_daily_water_consumption_per_user).to eq(0.0)
        expect(user.avg_daily_electricity_consumption).to eq(0.0)
        expect(house.average_daily_electricity_consumption_per_user).to eq(0.0)
    end
    it 'calculates resident averages for uniform bills' do
      User.create(first: "Rosa", last: "Rajan", email: "rjlil@gmail.com", password: "password", generation: 3)
      last_year = DateTime.now - 365
      UserHouse.create(user_id: User.last.id, house_id: @house.id, move_in_date: last_year)
      @house = House.first
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      kwhs = 1400
      price = rand(1..100)

        expect(@house.total_spent).to eq(0.0)
        #user added automatically to no_residents
        expect(@house.no_residents).to eq(2)

      #add bills
      ElectricBill.create(start_date: start_date1, end_date: end_date1, total_kwhs: kwhs, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: kwhs, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)
      HeatBill.create(start_date: start_date1, end_date: end_date1, total_therms: kwhs, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)

      #calculates per_resident score based on user_scores
      rachitha = User.find(@user.id)
      other = User.last
      rachithas_elct = rachitha.avg_daily_electricity_consumption
        expect(User.last.avg_daily_electricity_consumption).to eq(rachithas_elct)
        expect(House.find(@house.id).average_daily_electricity_consumption_per_user).to eq(rachithas_elct)
        expect(House.find(@house.id).average_total_electricity_consumption_per_resident).to eq(700)
        expect(House.find(@house.id).average_daily_electricity_consumption_per_resident.to_f.round(2)).to eq(rachithas_elct.to_f.round(2))

      #changing one residents total_logged, however, will change house.per_resident and house.per_user avgs
      rachitha.total_kwhs_logged += 1200
      rachitha.save
      rachithas_elct = rachitha.avg_daily_electricity_consumption
        expect(User.last.avg_daily_electricity_consumption).to_not eq(rachithas_elct)
        expect(House.find(@house.id).average_daily_electricity_consumption_per_user).to_not eq(rachithas_elct)
        expect(House.find(@house.id).average_daily_water_consumption_per_resident.to_f.round(2)).to_not eq(rachithas_elct.to_f.round(2))
        #changes total consumption, which is based on bills
        expect(House.find(@house.id).average_total_electricity_consumption_per_resident).to eq(700)

    end
  end
  context 'house with inconsistent users / users with history' do
    it 'calculates averages based on user logged behavior, not bills' do
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      kwhs = 1400
      price = rand(1..100)

        expect(@house.total_spent).to eq(0.0)

      #add bills
      ElectricBill.create(start_date: start_date1, end_date: end_date1, total_kwhs: kwhs, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)
      WaterBill.create(start_date: start_date1, end_date: end_date1, total_gallons: kwhs, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)
      HeatBill.create(start_date: start_date1, end_date: end_date1, total_therms: kwhs, price: price, house_id: @house.id, no_residents: 2, user_id: @user.id)
      #@user now has avg_daily_consumption
        expect(User.first.avg_daily_electricity_consumption.to_f.round(2)).to eq(23.33)
      #based on users personal averages; lost when no users exist in house
        expect(House.last.average_daily_electricity_consumption_per_user.to_f.round(2)).to eq(23.33)
      #based on house no_residents and total kwhs; does not maintain when no_residents changes
        expect(House.last.average_total_electricity_consumption_per_resident.to_f.round(2)).to eq(1400)

        expect(@house.users.empty?).to be false

      uhouse = UserHouse.where(user_id: @user.id, house_id: @house.id).first.destroy
      #remove @user from house, empyting house
      @house = House.find(@house.id)
        expect(User.first.houses.empty?).to be true
        expect(@house.users.empty?).to be true
        expect(@house.average_daily_electricity_consumption_per_user.to_f.round(2)).to eq(0.0)
      #####
      ## THIS IS INCORRECT --- PER / RESIDENT METHODS ARE ALL SCREWY;
       # They should also get restarted when no one lives in the house.

              expect(@house.average_total_electricity_consumption_per_resident.to_f.round(2)).to eq(0.0)
      #####
      daniel = User.create(first: "D", last: "John", email: "djohn@gmail.com", password: "password", generation: 1)
      carrie = User.create(first: "C", last: "Krask", email: "ckrask@gmail.com", password: "password", generation: 1)
      daniel.houses << @house
      carrie.houses << @house

        expect(@house.users.count).to eq(2)
        expect(@house.average_daily_electricity_consumption_per_user.to_f.round(2)).to eq(0.0)

      daniel.total_kwhs_logged = 1000
      daniel.total_electricitybill_days_logged = 30
      daniel.total_therms_logged = 10
      daniel.total_heatbill_days_logged = 30
      daniel.save
      daniel.total_gallons_logged = 1000
      daniel.total_waterbill_days_logged = 30
      daniel.save

      carrie.total_gallons_logged = 2000
      carrie.total_waterbill_days_logged = 30
      carrie.save

      house = House.last
     #house average = daniel average, since only he has elect/gas logs
        expect(house.average_daily_electricity_consumption_per_user.to_f.round(2)).to eq(33.33)
        expect(house.average_daily_gas_consumption_per_user.to_f.round(2)).to eq(0.33)

      #average of both users personal consumption avgs
        expect(daniel.avg_daily_water_consumption.to_f.round(2)).to eq(33.33)
        expect(carrie.avg_daily_water_consumption.to_f.round(2)).to eq(66.67)
        expect(house.average_daily_water_consumption_per_user.to_f.round(2)).to eq(50.0)

      UserHouse.last.destroy
      house = House.last
        #carrie removed from house
        expect(house.users.count).to eq(1)
        expect(house.users.first.email).to eq("djohn@gmail.com")
        #house averages all match daniel now:
        expect(house.average_daily_electricity_consumption_per_user.to_f.round(2)).to eq(33.33)
        expect(house.average_daily_gas_consumption_per_user.to_f.round(2)).to eq(0.33)
        expect(house.average_daily_water_consumption_per_user.to_f.round(2)).to eq(33.33)
    end
  end
  context 'house _per_resident calculations' do


  end
  context 'carbon calculations' do

  end
end
