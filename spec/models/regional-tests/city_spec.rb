require 'rails_helper'

RSpec.describe City, type: :model do
  before :each do
    avg = 12071.fdiv(30)
    wavg = 409466.6
    gavg = 10.88
    @country = Country.create(name: "Country-land", avg_daily_electricity_consumed_per_capita: avg, avg_daily_water_consumed_per_capita: wavg, avg_daily_gas_consumed_per_capita: gavg)
    @region = Region.create(name: "Region-land", country_id: @country.id)
    @city = City.create(name: "City1", region_id: @region.id)
    @city2 = City.create(name: "City2", region_id: @region.id)
    @county = County.create(name: "County-within", region_id: @region.id)
    @county2 = County.create(name: "County-without", region_id: @region.id)
    @neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: @city.id)
    @neighborhood2 = Neighborhood.create(name: "Other Neighborhood", city_id: @city2.id)
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
                              county_id: @county2.id,
                              city_id: @city2.id,
                              )
    #single user
    user = User.create(first: 'D', last: "Simpson", email: "d.simpson@gmail.com",
                        password: 'password', generation: 1)
    house = House.create(address_id: @address1.id, no_residents: 1, total_sq_ft: 3000)
    UserHouse.create(user_id: user.id, house_id: house.id, move_in_date: DateTime.now - 90)

    user2 = User.create(first: 'M', last: "Johnson", email: "m.johnson@gmail.com",
                        password: 'password', generation: 1)

    house = House.create(address_id: @address2.id, no_residents: 1, total_sq_ft: 3000)
    UserHouse.create(user_id: user2.id, house_id: house.id, move_in_date: DateTime.now - 90)

    user3 = User.create(first: 'J', last: "Geirgio", email: "j.geirgio@gmail.com",
                        password: 'password', generation: 1)

    house = House.create(address_id: @address3.id, no_residents: 1, total_sq_ft: 3000)
    UserHouse.create(user_id: user3.id, house_id: house.id, move_in_date: DateTime.now - 90)
  end
  context 'methods/ attributes' do
    it 'automatically capitalizes name' do
      city = City.create(name: "name", region_id: @region.id)
        expect(city.name).to eq "Name"
    end
    it 'initializes with zeros for averages' do
      city = City.create(name: "name", region_id: @region.id)
        expect(city.total_electricity_saved).to eq 0
        expect(city.total_water_saved).to eq 0
        expect(city.total_gas_saved).to eq 0
        expect(city.avg_total_electricity_saved_per_user).to eq 0
        expect(city.avg_total_water_saved_per_user).to eq 0
        expect(city.avg_total_gas_saved_per_user).to eq 0
        expect(city.avg_daily_electricity_consumed_per_user).to eq 0
        expect(city.avg_daily_water_consumed_per_user).to eq 0
        expect(city.avg_daily_gas_consumed_per_user).to eq 0
        expect(city.avg_daily_electricity_consumed_per_capita).to eq 0
        expect(city.avg_daily_water_consumed_per_capita).to eq 0
        expect(city.avg_daily_gas_consumed_per_capita).to eq 0
    end
  end
  context 'validations/ associations' do
    it {should validate_presence_of(:name)}
    it {should validate_uniqueness_of(:name).scoped_to(:region_id).case_insensitive}
    it {should belong_to(:region)}
    it {should have_many(:neighborhoods)}
    it {should have_many(:addresses)}
    it {should have_many(:houses)}
    it {should have_many(:users)}
    it {should have_many(:city_snapshots)}

    it {should have_one(:electricity_ranking)}
    it {should have_one(:water_ranking)}
    it {should have_one(:gas_ranking)}
    it {should have_one(:carbon_ranking)}

    it {should have_many(:user_electricity_rankings)}
    it {should have_many(:user_water_rankings)}
    it {should have_many(:user_gas_rankings)}
    it {should have_many(:user_carbon_rankings)}
  end
end
