require 'rails_helper'

RSpec.describe ElectricBill, type: :model do
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
    # @user = User.new(email: "dvog@gmail.com",
    #                 password: 'banana',
    #                 first: "Drake",
    #                 last: "Voogle",
    #                 generation: 0,
    #                 )
    # @user.houses << @house
    # @user.save
  end
  context 'a house' do
    it 'cant have bills with the same exact days' do
      today = DateTime.now
      el1 = ElectricBill.new(total_kwhs: 1000, start_date: today, end_date: (today + 30), house_id: @house.id)
      el2 = ElectricBill.new(total_kwhs: 1000,  start_date: today, end_date: (today + 30), house_id: @house.id)
      expect(el1.save).to be true
      expect(el2.save).to be false
    end
    it 'bill B cant save if start_date before the end_date of bill A' do
      today = DateTime.now
      bill_A = ElectricBill.new(total_kwhs: 1000, start_date: today, end_date: (today + 30), house_id: @house.id)
      bill_B = ElectricBill.new(total_kwhs: 1000,  start_date: today + 29, end_date: (today + 40), house_id: @house.id)
      expect(bill_A.save).to be true
      expect(bill_B.save).to be false
    end
    it 'bill B cant save if end_date after the start_date of bill A' do
      today = DateTime.now
      ago = DateTime.now - 30
      bill_A = ElectricBill.new(total_kwhs: 1000, start_date: today, end_date: (today + 30), house_id: @house.id)
      bill_B = ElectricBill.new(total_kwhs: 1000,  start_date: ago, end_date: (today + 1), house_id: @house.id)
      expect(bill_A.save).to be true
      expect(bill_B.save).to be false
    end
    it 'bill B CAN save if start_date and end_date BEFORE bill A' do
      today = DateTime.now
      ago = DateTime.now - 30
      bill_A = ElectricBill.new(total_kwhs: 1000, start_date: today, end_date: (today + 30), house_id: @house.id)
      bill_B = ElectricBill.new(total_kwhs: 1000,  start_date: ago, end_date: (today - 1), house_id: @house.id)
      expect(bill_A.save).to be true
      expect(bill_B.save).to be true
    end
    it 'bill B CAN save if start_date and end_date AFTER bill A' do
      today = DateTime.now
      ago = DateTime.now - 30
      bill_A = ElectricBill.new(total_kwhs: 1000, start_date: ago, end_date: (today - 1), house_id: @house.id)
      bill_B = ElectricBill.new(total_kwhs: 1000,  start_date: today, end_date: (today + 20), house_id: @house.id)
      expect(bill_A.save).to be true
      expect(bill_B.save).to be true
    end
  end
  context 'a house with different bill types' do
    it 'can be saved on the same day' do
      today = DateTime.now
      bill_1 = ElectricBill.new(total_kwhs: 1000, start_date: today, end_date: (today + 30), house_id: @house.id)
      bill_2 = WaterBill.new(total_gallons: 1000,  start_date: today, end_date: (today + 30), house_id: @house.id)
      expect(bill_1.save).to be true
      expect(bill_2.save).to be true
    end
  end
  context 'two different houses' do
    it 'can save along the same dates' do
      today = DateTime.now
      el1 = ElectricBill.new(total_kwhs: 1000, start_date: today, end_date: (today + 30), house_id: @house.id)
      el2 = ElectricBill.new(total_kwhs: 1000,  start_date: today, end_date: (today + 30), house_id: @house2.id)
      expect(el1.save).to be true
      expect(el2.save).to be true
    end
  end
end
