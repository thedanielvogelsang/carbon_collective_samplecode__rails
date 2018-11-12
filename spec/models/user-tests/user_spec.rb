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
    #same neighborhood no county
    address2 = Address.create(address_line1: "245 Second Address", zipcode_id: zip.id,
                              neighborhood_id: neighborhood.id,
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
    house = House.create(address_id: address1.id, no_residents: 0, total_sq_ft: 3000)
    UserHouse.create(user_id: @user1.id, house_id: house.id, move_in_date: DateTime.now - 90)

    @user2 = User.create(first: 'M', last: "Johnson", email: "m.johnson@gmail.com",
                        password: 'password', generation: 1)

    house2 = House.create(address_id: address2.id, no_residents: 0, total_sq_ft: 3000)
    UserHouse.create(user_id: @user2.id, house_id: house2.id, move_in_date: DateTime.now - 90)

    @user3 = User.create(first: 'J', last: "Geirgio", email: "j.geirgio@gmail.com",
                        password: 'password', generation: 1)

    house3 = House.create(address_id: address3.id, no_residents: 0, total_sq_ft: 3000)
    uh = UserHouse.create(user_id: @user3.id, house_id: house3.id, move_in_date: DateTime.now - 90)
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
      expect(@user3.first).to eq("J")
      expect(@user3.last).to eq("Geirgio")
      expect(@user3.email).to eq("j.geirgio@gmail.com")
      expect(@user3.password).to eq("password")
      expect(@user3.authenticate("password")).to eq(@user3)
    end
    it "password is hidden after save" do
      user3 = User.find(@user3.id)
      expect(@user3.password).to eq("password")
      expect(user3.password).to_not eq("password")
      expect(@user3.authenticate("password")).to eq(@user3)
      expect(user3.authenticate("password")).to eq(user3)
    end
    it "must set default ranks automatically" do
      user1 = User.find(@user1.id)

        expect(user1.user_electricity_rankings.count).to eq(6)
    end
    it "ranks are set for all of users regions from household to nation" do
      user1 = User.find(@user1.id)
      user2 = User.find(@user2.id)

      #user1 belongs to house, neighborhood, city, county, region, and country
        expect(user1.user_electricity_rankings.count).to eq(6)

      #user2 belongs to house, neighborhood, city, region, and country
        expect(user2.user_electricity_rankings.count).to eq(5)
    end
    it "ranks remain and are not recreated with addition of new house (same geography)" do
      user1 = User.find(@user1.id)
      user3 = User.find(@user3.id)
      #user1 belongs to house, neighborhood, city, county, region, and country
      rank = UserElectricityRanking.last
        expect(user1.user_electricity_rankings.count).to eq(6)
        expect(rank.area_id).to eq(user3.household.id)

      #user1 adds new house and set_default_ranks is ran
      address = Address.create(address_line1: "4590 New Address", zipcode_id: Zipcode.first.id,
                                neighborhood_id: Neighborhood.first.id,
                                city_id: City.first.id,
                                )
      new_house = House.create(address_id: address.id, no_residents: 0, total_sq_ft: 3000)
      user1.houses << new_house
      newest_rank = UserElectricityRanking.last
          #rank amount grows by only 1, which is the ranking for the new house, since geography is the same
          expect(user1.user_electricity_rankings.count).to eq(7)
          expect(user1.houses.count).to eq(2)
          expect(newest_rank.area_type).to eq("House")
          expect(newest_rank.area_id).to eq(new_house.id)
          expect(rank.id).to eq(newest_rank.id - 1)

    end
    it "ranks include new house regions (different geography)" do
      user1 = User.find(@user1.id)

      #user1 belongs to house, neighborhood, city, county, region, and country
      rank = UserElectricityRanking.last
        expect(user1.user_electricity_rankings.count).to eq(6)

      #user1 adds new house and set_default_ranks is ran
      address = Address.create(address_line1: "4590 New Address", zipcode_id: Zipcode.last.id,
                                neighborhood_id: Neighborhood.last.id,
                                city_id: City.last.id,
                                )
      new_house = House.create(address_id: address.id, no_residents: 0, total_sq_ft: 3000)
      user1.houses << new_house
      newest_rank = UserElectricityRanking.last
          #rank amount grows by 3, which is the ranking for the new house, neighborhood, and city
          expect(user1.user_electricity_rankings.count).to eq(9)
          expect(user1.houses.count).to eq(2)
          expect(newest_rank.area_type).to eq("House")
          expect(newest_rank.area_id).to eq(new_house.id)
          expect(rank.id).to eq(newest_rank.id - 3)
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
      user = User.last
      house = user.household
          expect(user.houses.first).to eq(house)
          expect(user.houses.count).to eq(1)

      address = Address.create(address_line1: "4590 New Address", zipcode_id: Zipcode.last.id,
                                neighborhood_id: Neighborhood.last.id,
                                city_id: City.last.id,
                                )
      new_house = House.create(address_id: address.id, no_residents: 0, total_sq_ft: 3000)
      user.houses << new_house
      user.save
          expect(user.houses.count).to eq(2)
          expect(user.household).to eq(house)
          expect(user.houses.second).to eq(new_house)

    end
    it 'user accrues resource-use data from all associated houses' do
        user = User.last
        house = user.household
            expect(user.houses.first).to eq(house)
            expect(user.houses.count).to eq(1)

        address = Address.create(address_line1: "4590 New Address", zipcode_id: Zipcode.last.id,
                                  neighborhood_id: Neighborhood.last.id,
                                  city_id: City.last.id,
                                  )
        much_older_house = House.create(address_id: address.id, no_residents: 0, total_sq_ft: 3000)
        UserHouse.create(user_id: user.id, house_id: much_older_house.id, move_in_date: DateTime.now - 5000)
        user.save
            expect(user.houses.count).to eq(2)
            expect(user.household).to eq(house)
            expect(user.houses.second).to eq(much_older_house)

        ### user begins importing old bills for both houses:
        #adds bills to first house
        yesterday = DateTime.now - 30
        ago = DateTime.now - 60
        bill_A = ElectricBill.create(total_kwhs: 1000, price: 1, start_date: yesterday, end_date: (yesterday + 30), house_id: house.id, no_residents: 1, who: user)
        bill_B = ElectricBill.create(total_kwhs: 2000, price: 1,  start_date: ago, end_date: (yesterday - 1), house_id: house.id, no_residents: 1, who: user)
        bill_C = WaterBill.create(total_gallons: 1000, price: 1, start_date: ago, end_date: (yesterday - 1), house_id: house.id, no_residents: 1, who: user)
        bill_D = WaterBill.create(total_gallons: 2000, price: 1,  start_date: yesterday, end_date: (yesterday + 30), house_id: house.id, no_residents: 1, who: user)
        user = User.find(user.id)
        u_eavg = user.avg_daily_electricity_consumption
        u_wavg = user.avg_daily_water_consumption
            expect(u_eavg.to_f.round(2)).to eq(50.85)
            expect(u_wavg.to_f.round(2)).to eq(50.85)

        #adds bills to old house
        bill_B = ElectricBill.create(total_kwhs: 3000, price: 1,  start_date: ago, end_date: (yesterday - 1), house_id: much_older_house.id, no_residents: 1, who: user, force: true)
        bill_C = WaterBill.create(total_gallons: 3000, price: 1, start_date: ago, end_date: (yesterday - 1), house_id: much_older_house.id, no_residents: 1, who: user, force: true)

        #which updates users averages
        user = User.find(user.id)
        new_u_eavg = user.avg_daily_electricity_consumption
        new_u_wavg = user.avg_daily_water_consumption
              expect(new_u_eavg.to_f.round(2)).to eq(68.18)
            expect(new_u_wavg.to_f.round(2)).to eq(68.18)

        #while houses retain separate info
        house = House.find(house.id)
        old_house = House.find(much_older_house.id)
          expect(house.total_spent).to eq(4)
          expect(house.total_days_recorded).to eq(118)
          expect(house.total_electricity_consumption_to_date).to eq(3000)
          expect(house.total_water_consumption_to_date).to eq(3000)
          expect(old_house.total_spent).to eq(2)
          expect(old_house.total_days_recorded).to eq(58)
          expect(old_house.total_electricity_consumption_to_date).to eq(3000)
          expect(old_house.total_water_consumption_to_date).to eq(3000)
          #with same user averages (since theres only one user in each house)
          old_house_user_avg = old_house.average_daily_water_consumption_per_user.to_f.round(2)
          new_house_user_avg = house.average_daily_water_consumption_per_user.to_f.round(2)
          expect(old_house_user_avg).to eq(68.18)
          expect(new_house_user_avg).to eq(68.18)
          expect(new_house_user_avg).to eq(old_house_user_avg)
    end
    it 'user can permanently leave house' do
        user = User.last
        house = user.household
        UserHouse.where(user_id: user.id, house_id: house.id)[0].destroy
        user.save
          expect(user.houses.count).to eq(0)
          expect(user.household).to eq(nil)
          expect(user.houses.first).to eq(nil)
    end
    it 'user can leave house and come back with same house data (so long as there are still residents in household)' do
      user = User.last
      house = user.household
      house.no_residents = 2
      house.save
        expect(user.houses.count).to eq(1)
        expect(house.no_residents).to eq(2)
      ### house has bills :
      yesterday = DateTime.now - 30
      ago = DateTime.now - 60
      bill_A = ElectricBill.create(total_kwhs: 1000, price: 1, start_date: yesterday, end_date: (yesterday + 30), house_id: house.id, no_residents: 1, who: user)
      bill_B = ElectricBill.create(total_kwhs: 2000, price: 1,  start_date: ago, end_date: (yesterday - 1), house_id: house.id, no_residents: 1, who: user)
      bill_C = WaterBill.create(total_gallons: 1000, price: 1, start_date: ago, end_date: (yesterday - 1), house_id: house.id, no_residents: 1, who: user)
      bill_D = WaterBill.create(total_gallons: 2000, price: 1,  start_date: yesterday, end_date: (yesterday + 30), house_id: house.id, no_residents: 1, who: user)
      user = User.find(user.id)
      u_eavg = user.avg_daily_electricity_consumption
      u_wavg = user.avg_daily_water_consumption
      h_eavg = house.average_daily_electricity_consumption_per_user
      h_wavg = house.average_daily_water_consumption_per_user
          expect(u_eavg.to_f.round(2)).to eq(50.85)
          expect(u_wavg.to_f.round(2)).to eq(50.85)
          expect(h_wavg.to_f.round(2)).to eq(50.85)
          expect(h_wavg.to_f.round(2)).to eq(50.85)

      #user leaves house
      UserHouse.find_by(user_id: user.id).destroy
      user = User.last
      house = House.find(house.id)
          expect(user.houses.empty?).to be true
          expect(house.users.empty?).to be true
          expect(house.no_residents).to eq(0)
      #house no longer has user averages
      u_eavg = user.avg_daily_electricity_consumption
      u_wavg = user.avg_daily_water_consumption
      h_eavg = house.average_daily_electricity_consumption_per_user
      h_wavg = house.average_daily_water_consumption_per_user
          expect(u_eavg.to_f.round(2)).to eq(50.85)
          expect(u_wavg.to_f.round(2)).to eq(50.85)
          expect(h_wavg.to_f.round(2)).to eq(0.0)
          expect(h_wavg.to_f.round(2)).to eq(0.0)
    end
    it 'user can join an (existing) house with users already in it' do
        new_user = User.create(first: 'X', last: "Men", email: "xavier@gmail.com",
                            password: 'pword', generation: 1)
        house = House.last
            expect(house.no_residents).to eq(1)
            expect(house.users.count).to eq(1)
            expect(house.users.first).to eq(@user3)

        new_user.houses << house
        new_user.save
        house = House.last
            expect(house.no_residents).to eq(2)
            expect(house.users.count).to eq(2)
            expect(house.users.first).to eq(@user3)
            expect(house.users.second).to eq(new_user)
    end
    it 'user can invite people' do
      new_user = User.create(first: 'X', last: "Men", email: "xavier@gmail.com",
                          password: 'pword', generation: 1)
      user = User.second
          expect(user.email).to eq("m.johnson@gmail.com")

      UserInvite.create(user_id: user.id, invite_id: new_user.id)
      user = User.second
          expect(user.invites.count).to eq(1)
          expect(user.invites.first).to eq(new_user)
    end
  end
end
