require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    avg = 12071.fdiv(30)
    wavg = 409466.6
    gavg = 10.88
    country = Country.create(name: "Country-land", avg_daily_electricity_consumed_per_capita: avg, avg_daily_water_consumed_per_capita: wavg, avg_daily_gas_consumed_per_capita: gavg)
    region = Region.create(name: "Region-land", country_id: country.id)
    city = City.create(name: "City1", region_id: region.id)
    city2 = City.create(name: "City2", region_id: region.id)
    county = County.create(name: "County-within", region_id: region.id)
    county2 = County.create(name: "County-without", region_id: region.id)
    neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: city.id)
    neighborhood2 = Neighborhood.create(name: "Other Neighborhood", city_id: city2.id)
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
    #same neighborhood
    address2 = Address.create(address_line1: "245 Second Address", zipcode_id: zip.id,
                              neighborhood_id: neighborhood.id,
                              county_id: county.id,
                              city_id: city.id,
                              )
    #different neighborhood, same city
    address3 = Address.create(address_line1: "678 Third Address", zipcode_id: zip.id,
                              neighborhood_id: neighborhood2.id,
                              county_id: county2.id,
                              city_id: city2.id,
                              )
    #single user
    @user1 = User.create(first: 'D', last: "Simpson", email: "d.simpson@gmail.com",
                        password: 'password', generation: 1)
    house = House.create(address_id: address1.id, no_residents: 1, total_sq_ft: 3000)
    UserHouse.create(user_id: @user1.id, house_id: house.id, move_in_date: DateTime.now - 90)

    @user2 = User.create(first: 'M', last: "Johnson", email: "m.johnson@gmail.com",
                        password: 'password', generation: 1)

    house2 = House.create(address_id: address2.id, no_residents: 1, total_sq_ft: 3000)
    UserHouse.create(user_id: @user2.id, house_id: house2.id, move_in_date: DateTime.now - 90)

    @user3 = User.create(first: 'J', last: "Geirgio", email: "j.geirgio@gmail.com",
                        password: 'password', generation: 1)

    house3 = House.create(address_id: address3.id, no_residents: 1, total_sq_ft: 3000)
    UserHouse.create(user_id: @user3.id, house_id: house3.id, move_in_date: DateTime.now - 90)
  end
  context 'relationships' do
    it {should have_many(:groups)}
    it {should have_many(:trips)}
    it {should have_many(:admins)}
    it {should have_and_belong_to_many(:friendships)}
  end
  context 'methods and attributes' do
    it 'is initialized without invite and confirmation tokens but receives them upon creation' do
      new_user = User.new
      user1 = User.first
      expect(user1.id).to eq(@user1.id)

        expect(new_user.invite_token).to be nil
        expect(new_user.confirm_token).to be nil
        expect(user1.invite_token).to_not be nil
        expect(user1.confirm_token).to_not be nil
    end
    it "can call all attributes" do

    end
    it "must set default ranks manually" do

    end
    it "each user automatically gets user_questions upon UserHouse creation" do
      user1 = User.find(@user1.id)
      user2 = User.find(@user2.id)
      user3 = User.find(@user3.id)
      new_user = User.create(first: 'X', last: "Men", email: "xavier@gmail.com",
                          password: 'pword', generation: 1)
          #new user exists
          expect(new_user.id).to be(@user3.id + 1)

          #new user has no user_questions but the other users do
          expect(new_user.user_electricity_questions.empty?).to be true
          expect(user1.user_electricity_questions.empty?).to be false
          expect(user2.user_electricity_questions.empty?).to be false
          expect(user3.user_electricity_questions.empty?).to be false
          #joining a house automatically creates questions
    end
  end
  context 'behaviors' do
    it 'user can own two houses' do

    end
    it 'user accrues resource-use data from all associated houses' do

    end
    it 'user can permanently leave house' do

    end
    it 'user can leave house and come back with same house data (so long as there are still residents in household)' do

    end
    it 'user can join an (existing) house with users already in it' do

    end
    it 'user can invite people' do

    end
  end
end
