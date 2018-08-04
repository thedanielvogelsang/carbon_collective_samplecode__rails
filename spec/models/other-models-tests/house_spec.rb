require 'rails_helper'

RSpec.describe House, type: :model do
  context 'validations' do
    it{should validate_presence_of(:address_id)}
  end
  context 'relationships' do
    it{should belong_to(:address)}
  end
  context 'house model methods' do
    before :each do
      avg = 12071.fdiv(30)
      wavg = 409466.6
      gavg = 10.88
      country = Country.create(name: "Country-land", avg_daily_electricity_consumed_per_capita: avg, avg_daily_water_consumed_per_capita: wavg, avg_daily_gas_consumed_per_capita: gavg)
      region = Region.create(name: "Region-land", country_id: country.id)
      city = City.create(name: "City", region_id: region.id)
      county = County.create(name: "County-within", region_id: region.id)
      neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: city.id)
      neighborhood2 = Neighborhood.create(name: "Other Neighborhood", city_id: city.id)
      zip = Zipcode.create(zipcode: 80291)
      start_date1 = DateTime.now - 30
      end_date1 = DateTime.now
      start_date2 = DateTime.now - 61
      end_date2 = DateTime.now - 31
      address1 = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                                neighborhood_id: neighborhood.id,
                                county_id: county.id,
                                city_id: city.id,
                                )
      #single user
      @user = User.create(first: 'D', last: "Simpson", email: "d.simpson@gmail.com",
                          password: 'password', generation: 1)
      @house = House.create(address_id: address1.id, no_residents: 1, total_sq_ft: 3000)
        @yesterday = DateTime.now - 90
        UserHouse.create(user_id: @user.id, house_id: @house.id, move_in_date: (@yesterday - 3))
      #massive number of bills in history
      @bill_1 = ElectricBill.create(total_kwhs: 1000, start_date: @yesterday, end_date: (@yesterday + 29), house_id: @house.id, no_residents: 2, who: @user)
      @bill_2 = ElectricBill.create(total_kwhs: 1000, start_date: @yesterday + 30, end_date: (@yesterday + 61), house_id: @house.id, no_residents: 2, who: @user)
      @bill_3 = ElectricBill.create(total_kwhs: 1000, start_date: @yesterday + 62, end_date: (@yesterday + 89), house_id: @house.id, no_residents: 2, who: @user)
      @bill_4 = WaterBill.create(total_gallons: 1000, start_date: @yesterday, end_date: (@yesterday + 29), house_id: @house.id, no_residents: 2, who: @user)
      @bill_5 = WaterBill.create(total_gallons: 1000, start_date: @yesterday + 30, end_date: (@yesterday + 61), house_id: @house.id, no_residents: 2, who: @user)
      @bill_6 = WaterBill.create(total_gallons: 1000, start_date: @yesterday + 62, end_date: (@yesterday + 89), house_id: @house.id, no_residents: 2, who: @user)
      @bill_7 = HeatBill.create(total_therms: 1000, start_date: @yesterday, end_date: (@yesterday + 29), house_id: @house.id, no_residents: 2, who: @user)
      @bill_7 = HeatBill.create(total_therms: 1000, start_date: @yesterday + 30, end_date: (@yesterday + 61), house_id: @house.id, no_residents: 2, who: @user)
      @bill_8 = HeatBill.create(total_therms: 1000, start_date: @yesterday + 62, end_date: (@yesterday + 89), house_id: @house.id, no_residents: 2, who: @user)
    end
    it 'can erase all bill history if no_resident equals 0' do
      house = House.last
        expect(house.id).to eq(@house.id)
        expect(house.bills.count).to eq(3)
        expect(house.wbills.count).to eq(3)
        expect(house.gbills.count).to eq(3)
        expect(house.all_bills_to_date.count).to eq(9)

      house.no_residents = 0
      house.save
        expect(house.bills.count).to eq(0)
        expect(house.wbills.count).to eq(0)
        expect(house.gbills.count).to eq(0)
    end
  end
end
