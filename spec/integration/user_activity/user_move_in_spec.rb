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
    UserHouse.create(house_id: @house.id, user_id: @new_user.id, move_in_date: DateTime.now - 31)
    ago = DateTime.now - 29
    ago2 = DateTime.now - 59
    ago3 = DateTime.now - 89
    @el1 = ElectricBill.create(total_kwhs: 1000, start_date: ago, end_date: (ago + 29), house_id: @house.id, no_residents: 2, who: @old_user)
    @el2 = ElectricBill.create(total_kwhs: 1000,  start_date: ago2, end_date: (ago2 + 29), house_id: @house.id, no_residents: 2, who: @old_user)
    @heat_A = HeatBill.create(total_therms: 10, start_date: ago2, end_date: (ago2 + 29), no_residents: 2, house_id: @house.id, who: @old_user, force: true)
    @heat_B = HeatBill.create(total_therms: 10,  start_date: ago3, end_date: (ago3 + 29), no_residents: 2, house_id: @house.id, who: @old_user, force: true)
end
  context 'User expands move_in_date time window' do
    it 'can only see correlating bills if re-update (worker, on app) is triggered' do
        user = User.second
          expect(user.first + " " + user.last).to eq("New Roomie")
        uh = UserHouse.last
          expect(uh.user_id).to eq(user.id)
        # original bill count equal to 1 (because he moved in after @el1 and @heat_B)
        old_electric = user.electric_bills
          expect(old_electric.count).to eq(1)
          # total bill count equal to 1 also
          expect(user.bills.count).to eq(1)
          expect(old_electric.first.start_date >= user.user_houses.first.move_in_date).to be true
          expect(ElectricBill.last.start_date >= user.user_houses.first.move_in_date).to be false

        # changes move in date
        new_move_in_date = DateTime.now - 90

        old_move_in_date = uh.move_in_date
          expect(uh.move_in_date >= new_move_in_date)
        uh.update(move_in_date: new_move_in_date)

     ## ISNT ASSOCIATED UNTIL AFTER RE_UPDATE OCCURS (user_helper)
        # sees only same first electric bills
        new_electric = user.electric_bills
          expect(new_electric.count).to eq(1)
          expect(new_electric.first).to eq(@el1)
          ## re_calculate ##
          user.re_calculate_bill_history(old_move_in_date)

        # now sees both electric bills
        new_electric = user.electric_bills
          expect(new_electric.count).to eq(2)

        # also absorbs the heatbill within range
        bills = user.bills
          expect(bills.count).to eq(3)

        #but not the final heat bill (which predates user2s new move_in_date)
          expect(bills.last.id).to eq(@heat_A.id)
          expect(bills.include?(@heat_B)).to be false
    end
    it 'sees a reflection in score' do

    end
  end
end
