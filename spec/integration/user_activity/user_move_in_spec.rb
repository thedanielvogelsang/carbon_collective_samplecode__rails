require 'rails_helper'

RSpec.describe 'Users move-in-dates effect score' do
  before :each do
    ctry = Country.create(name: "United States of America", avg_daily_electricity_consumed_per_capita: 12071.fdiv(30),
                  avg_daily_water_consumed_per_capita: 101.5,
                  avg_daily_gas_consumed_per_capita: 0.5)
    al = ["Colorado", 1211, 82, 10.92]
    state_avg = "%0.6f" % (("%0.6f" % al[1]).to_f / ("%0.6f" % 30).to_f)
    reg = Region.create(name: al[0], avg_daily_electricity_consumed_per_capita: state_avg,
                  avg_daily_water_consumed_per_capita: al[2],
                  avg_daily_gas_consumed_per_capita: al[3],
                  country_id: ctry.id,
                 )
    city = City.create(name: "Denver", region_id: reg.id)
    n = Neighborhood.create(name: "Neighborhood", city_id: city.id)
    zip = Zipcode.create(zipcode: "80218")
    add = Address.create(address_line1: "404 Marshall Rd", city_id: city.id, zipcode_id: zip.id, neighborhood_id: n.id)

    @house = House.create(total_sq_ft: rand(1500..2000), no_residents: 2, address_id: add.id)
    @old_user = User.create(email: "dben@gmail.com",
                    password: 'banana',
                    first: "Original",
                    last: "Housemember",
                    generation: 0,
                    )
    @new_user = User.create(email: "tand@gmail.com",
                    password: 'banana',
                    first: "New",
                    last: "Roomie",
                    generation: 1,
                    )
    UserHouse.create(house_id: @house.id, user_id: @old_user.id, move_in_date: DateTime.now - 90)
    UserHouse.create(house_id: @house.id, user_id: @new_user.id, move_in_date: DateTime.now - 30)
    ago = DateTime.now - 29
    ago2 = DateTime.now - 59
    el1 = ElectricBill.create(total_kwhs: 1000, start_date: ago, end_date: (ago + 29), house_id: @house.id, no_residents: 2, who: @old_user)
    el2 = ElectricBill.create(total_kwhs: 1000,  start_date: ago2, end_date: (ago2 + 29), house_id: @house.id, no_residents: 2, who: @old_user)
  end
  context 'User expands move_in_date time window' do
    it 'can now see correlating bills' do
        user = User.second
          expect(user.first + " " + user.last).to eq("New Roomie")
        old_bills = user.bills
          expect(old_bills.count).to eq(1)
          expect(old_bills.first.start_date > user.user_houses.first.move_in_date).to be true
          expect(ElectricBill.last.start_date > user.user_houses.first.move_in_date).to be false
        new_move_in_date = DateTime.now - 90
        uh = UserHouse.last
          expect(uh.move_in_date >= new_move_in_date)
        uh.update(move_in_date: new_move_in_date)
        bills = user.bills
          expect(bills.count).to eq(2)
    end
    it 'sees a reflection in score' do

    end
  end
end
