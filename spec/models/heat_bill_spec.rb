require 'rails_helper'

RSpec.describe HeatBill, type: :model do
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
    @house = House.create(total_sq_ft: rand(1500..2000), no_residents: 2, address_id: add.id)
  end
  context 'a house' do
    it 'cant have bills with the same exact days' do
      today = DateTime.now
      el1 = HeatBill.new(total_therms: 1000, start_date: today, end_date: (today + 30), house_id: @house.id)
      el2 = HeatBill.new(total_therms: 1000,  start_date: today, end_date: (today + 30), house_id: @house.id)
      expect(el1.save).to be true
      expect(el2.save).to be false
    end
    it 'bill B cant save if start_date before the end_date of bill A' do
      today = DateTime.now
      bill_A = HeatBill.new(total_therms: 1000, start_date: today, end_date: (today + 30), house_id: @house.id)
      bill_B = HeatBill.new(total_therms: 1000,  start_date: today + 29, end_date: (today + 40), house_id: @house.id)
      expect(bill_A.save).to be true
      expect(bill_B.save).to be false
    end
    it 'bill B cant save if end_date after the start_date of bill A' do
      today = DateTime.now
      ago = DateTime.now - 30
      bill_A = HeatBill.new(total_therms: 1000, start_date: today, end_date: (today + 30), house_id: @house.id)
      bill_B = HeatBill.new(total_therms: 1000,  start_date: ago, end_date: (today + 1), house_id: @house.id)
      expect(bill_A.save).to be true
      expect(bill_B.save).to be false
    end
    it 'bill B CAN save if start_date and end_date BEFORE bill A' do
      today = DateTime.now
      ago = DateTime.now - 30
      bill_A = HeatBill.new(total_therms: 1000, start_date: today, end_date: (today + 30), house_id: @house.id)
      bill_B = HeatBill.new(total_therms: 1000,  start_date: ago, end_date: (today - 1), house_id: @house.id)
      expect(bill_A.save).to be true
      expect(bill_B.save).to be true
    end
    it 'bill B CAN save if start_date and end_date AFTER bill A' do
      today = DateTime.now
      ago = DateTime.now - 30
      bill_A = HeatBill.new(total_therms: 1000, start_date: ago, end_date: (today - 1), house_id: @house.id)
      bill_B = HeatBill.new(total_therms: 1000,  start_date: today, end_date: (today + 20), house_id: @house.id)
      expect(bill_A.save).to be true
      expect(bill_B.save).to be true
    end
  end
end
