require 'rails_helper'

RSpec.describe WaterBill, type: :model do
  require 'rails_helper'
  before :each do
    ctry = Country.create(name: "United States of America", avg_daily_electricity_consumed_per_capita: 12071.fdiv(30),
                  avg_daily_water_consumed_per_capita: 101.5,
                  avg_daily_gas_consumed_per_capita: 0.5)
    al = ["Alabama", 1211, 82, 10.92]
    state_avg = "%0.6f" % (("%0.6f" % al[1]).to_f / ("%0.6f" % 30).to_f)
    reg = Region.create(name: al[0], avg_daily_electricity_consumed_per_capita: state_avg,
                  avg_daily_water_consumed_per_capita: al[2],
                  avg_daily_gas_consumed_per_capita: al[3],
                  country_id: ctry.id,
                 )
    city = City.create(name: "Denver", region_id: reg.id)
    zip = Zipcode.create(zipcode: "80218")
    add = Address.create(address_line1: "404 Marshall Rd", city_id: city.id, zipcode_id: zip.id)
    add2 = Address.create(address_line1: "505 Someplace Else", city_id: city.id, zipcode_id: zip.id)

    @house = House.create(total_sq_ft: rand(1500..2000), no_residents: 2, address_id: add.id)
    @house2 = House.create(total_sq_ft: rand(2500..3000), no_residents: 3, address_id: add2.id)
    @user = User.create(email: "dvog@gmail.com",
                    password: 'banana',
                    first: "Drake",
                    last: "Voogle",
                    generation: 0,
                    )
    UserHouse.create(house_id: @house.id, user_id: @user.id, move_in_date: DateTime.now - 30)
    UserHouse.create(house_id: @house2.id, user_id: @user.id, move_in_date: DateTime.now - 30)
  end
  context 'a house' do
    it 'cant have bills with the same exact days' do
      yesterday = DateTime.now - 29
      el1 = WaterBill.new(total_gallons: 1000,  start_date: yesterday, end_date: (yesterday + 29), house_id: @house.id, no_residents: 2, who: @user)
      el2 = WaterBill.new(total_gallons: 1000,  start_date: yesterday, end_date: (yesterday + 29), house_id: @house.id, no_residents: 2, who: @user)
      expect(el1.save).to be true
      expect(el2.save).to be false
      expect(el2.errors.messages).to eq({:start_date=>["start or end date overlaps with another bill"]})
    end
    it 'bill B cant save if start_date before the end_date of bill A' do
      yesterday = DateTime.now - 29
      bill_A = WaterBill.new(total_gallons: 1000, start_date: yesterday, end_date: (yesterday + 11), house_id: @house.id, no_residents: 2, who: @user)
      bill_B = WaterBill.new(total_gallons: 1000,  start_date: yesterday + 10, end_date: (yesterday + 29), house_id: @house.id, no_residents: 2, who: @user)
      expect(bill_A.save).to be true
      expect(bill_B.save).to be false
      expect(bill_B.errors.messages).to eq({:start_date=>["start or end date overlaps with another bill"]})
    end
    it 'bill B cant save if end_date after the start_date of bill A' do
      yesterday = DateTime.now - 20
      ago = DateTime.now - 29
      bill_A = WaterBill.new(total_gallons: 1000, start_date: yesterday, end_date: (yesterday + 20), house_id: @house.id, no_residents: 2, who: @user)
      bill_B = WaterBill.new(total_gallons: 1000,  start_date: ago, end_date: (yesterday + 1), house_id: @house.id, no_residents: 2, who: @user)
      expect(bill_A.save).to be true
      expect(bill_B.save).to be false
      expect(bill_B.errors.messages).to eq({:start_date=>["start or end date overlaps with another bill"]})
    end
    it 'bill B CAN save if start_date and end_date BEFORE bill A' do
      yesterday = DateTime.now - 20
      ago = DateTime.now - 29
      bill_A = WaterBill.new(total_gallons: 1000, start_date: yesterday, end_date: (yesterday + 20), house_id: @house.id, no_residents: 2, who: @user)
      bill_B = WaterBill.new(total_gallons: 1000,  start_date: ago, end_date: (yesterday - 1), house_id: @house.id, no_residents: 2, who: @user)
      expect(bill_A.save).to be true
      expect(bill_B.save).to be true
    end
    it 'bill B CAN save if start_date and end_date AFTER bill A' do
      yesterday = DateTime.now - 20
      ago = DateTime.now - 29
      bill_A = WaterBill.new(total_gallons: 1000, start_date: ago, end_date: (yesterday - 1), house_id: @house.id, no_residents: 2, who: @user)
      bill_B = WaterBill.new(total_gallons: 1000,  start_date: yesterday, end_date: (yesterday + 20), house_id: @house.id, no_residents: 2, who: @user)
      expect(bill_A.save).to be true
      expect(bill_B.save).to be true
    end
    context 'a house with revolving users' do
      it 'cannot save bills BEFORE single house-members move_in_date' do
        #user tries to save a bill for a date that precedes his move_in_date
        uH = UserHouse.first
          expect(uH.user_id).to eq(@user.id)

        #bill should not be able to save if dated before move-in of 'oldest' resident
        move_in_date = uH.move_in_date.to_datetime
        sdate = move_in_date - 31
        edate = move_in_date - 1
        eb = WaterBill.new(total_gallons: 1000, start_date: sdate, end_date: edate, house_id: @house.id, no_residents: 2, who: @user)
        expect(eb.save).to be false

        uH.move_in_date = sdate - 30
        uH.save
        #now a bill can be saved because it comes AFTER move_in_date
        eb = WaterBill.new(total_gallons: 1000, start_date: sdate, end_date: edate, house_id: @house.id, no_residents: 2, who: @user)
        expect(eb.save).to be true
      end
      it 'can save bills up to earliest members move-in-date' do
        #house has user who moved in 90 days ago, as well as @user, which moved in 30 days ago
        old_user = User.create(
                              first: "Grandpa",
                              last: "User", email: "gramps@gmail.com",
                              generation: 1, password: 'password'
                              )
        new_user = @user
        move_in_date = DateTime.now - 90
        UserHouse.create(house_id: @house.id, user_id: old_user.id, move_in_date: move_in_date)
            #confirms move in dates of older vs new user
            uH_oldUser = UserHouse.last
              expect(uH_oldUser.user_id).to eq(old_user.id)

            uH_newUser = UserHouse.first
              expect(uH_newUser.user_id).to eq(new_user.id)

              expect(uH_newUser.move_in_date > uH_oldUser.move_in_date).to be true

        #bill can be saved only by older resident
        move_in_date = uH_newUser.move_in_date.to_datetime
        sdate = move_in_date - 31
        edate = move_in_date - 1

        #false
        eb = WaterBill.new(total_gallons: 1000,  start_date: sdate, end_date: edate, house_id: @house.id, no_residents: 2, who: @user)
          expect(eb.save).to be false
        #true
        eb = WaterBill.new(total_gallons: 1000,  start_date: sdate, end_date: edate, house_id: @house.id, no_residents: 2, who: old_user)
          expect(eb.save).to be true

      end
      it 'cannot save bills past the current date' do
        #future bill dates are rejected (MODEL LEVEL)
        #user tries to save a bill for a date that is past 'today'
        uH = UserHouse.first
          expect(uH.user_id).to eq(@user.id)

        move_in_date = uH.move_in_date.to_datetime
        sdate = DateTime.now - 29
        edate = DateTime.now + 1
        eb = WaterBill.new(total_gallons: 1000,  start_date: sdate, end_date: edate, house_id: @house.id, no_residents: 2, who: @user)
        expect(eb.save).to be false
        expect(eb.errors.messages).to eq({:end_date => ["cannot claim future use on past bills"]})

        edate = DateTime.now
        # redefined end_date to today, now a bill can be saved
        eb = WaterBill.new(total_gallons: 1000,  start_date: sdate, end_date: edate, house_id: @house.id, no_residents: 2, who: @user)
        expect(eb.save).to be true
      end
      it 'bill saves update users whos move in dates precede bill date' do
        #three users in house: 1 who just moved in, and 2 which have lived there awhile.
        # one of the latter two save a bill, both are update, new_user is NOT
        #house has user who moved in 90 days ago, user who moved in 62 days ago,
            # as well as @user, who moved in 30 days ago
        new_user = @user
        old_user = User.create(
                              first: "Dad",
                              last: "User", email: "dads@gmail.com",
                              generation: 2, password: 'password'
                              )

        move_in_date = DateTime.now - 62
        UserHouse.create(house_id: @house.id, user_id: old_user.id, move_in_date: move_in_date)

        oldest_user = User.create(
                              first: "Grandpa",
                              last: "User", email: "gramps@gmail.com",
                              generation: 1, password: 'password'
                              )

        new_user = @user
        move_in_date = DateTime.now - 90
        UserHouse.create(house_id: @house.id, user_id: oldest_user.id, move_in_date: move_in_date)

            #confirms move in dates of older vs new user
            uH_oldestUser = UserHouse.last
              expect(uH_oldestUser.user_id).to eq(oldest_user.id)

            uH_oldUser = UserHouse.find(uH_oldestUser.id - 1)
            expect(uH_oldUser.user_id).to eq(old_user.id)

            uH_newUser = UserHouse.first
              expect(uH_newUser.user_id).to eq(new_user.id)

              expect(uH_newUser.move_in_date > uH_oldUser.move_in_date).to be true
              expect(uH_oldUser.move_in_date > uH_oldestUser.move_in_date).to be true

        #bill can be saved only by older resident
        move_in_date = uH_newUser.move_in_date.to_datetime
        sdate = move_in_date - 31
        edate = move_in_date - 1

        new_user_score = new_user.avg_daily_water_consumption
        old_user_score = old_user.avg_daily_water_consumption
        oldest_user_score = oldest_user.avg_daily_water_consumption

        #false
        eb = WaterBill.new(total_gallons: 1000,  start_date: sdate, end_date: edate, house_id: @house.id, no_residents: 2, who: @user)
          expect(eb.save).to be false
        #true
        eb = WaterBill.new(total_gallons: 1000,  start_date: sdate, end_date: edate, house_id: @house.id, no_residents: 2, who: old_user)
          expect(eb.save).to be true

        new_user_score_NEW = User.find(new_user.id).avg_daily_water_consumption
        old_user_score_NEW = User.find(old_user.id).avg_daily_water_consumption
        oldest_user_score_NEW = User.find(oldest_user.id).avg_daily_water_consumption
        #updates BOTH users info but not new_user
          expect(old_user_score_NEW).to_not eq(old_user_score)
          expect(oldest_user_score_NEW).to_not eq(oldest_user_score)

          expect(new_user_score_NEW).to eq(new_user_score)
      end
    end
    context 'a house with different bill types' do
      it 'can be saved on the same day' do
        yesterday = DateTime.now - 29
        bill_1 = ElectricBill.new(total_kwhs: 1000, start_date: yesterday, end_date: (yesterday + 29), house_id: @house.id, no_residents: 2, who: @user)
        bill_2 = WaterBill.new(total_gallons: 1000,  start_date: yesterday, end_date: (yesterday + 29), house_id: @house.id, no_residents: 2, who: @user)
        expect(bill_1.save).to be true
        expect(bill_2.save).to be true
      end
    end
    context 'two different houses' do
      it 'can save along the same dates' do
        yesterday = DateTime.now - 29
        el1 = WaterBill.new(total_gallons: 1000,  start_date: yesterday, end_date: (yesterday + 29), house_id: @house.id, no_residents: 2, who: @user)
        el2 = WaterBill.new(total_gallons: 1000,  start_date: yesterday, end_date: (yesterday + 29), house_id: @house2.id, no_residents: 2, who: @user)
        expect(el1.save).to be true
        expect(el2.save).to be true
      end
    end
  end
end
