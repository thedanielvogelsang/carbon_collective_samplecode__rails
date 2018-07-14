require 'rails_helper'

RSpec.describe 'neighborhood consumption averages' do
  before :each do
    @country = Country.create(name: "Country-land")
    @region = Region.create(name: "Region-land", country_id: 1)
    @city = City.create(name: "City", region_id: 1)
    @county = County.create(name: "County-within", region_id: 1)
    @neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: 1)
    @neighborhood2 = Neighborhood.create(name: "Other Neighborhood", city_id: 1)
    @zip = Zipcode.create(zipcode: 80291)
    @start_date1 = DateTime.now - 30
    @end_date1 = DateTime.now
    @start_date2 = DateTime.now - 60
    @end_date2 = DateTime.now - 31
    @address1 = Address.create(address_line1: "123 My Address", zipcode_id: 1,
                              neighborhood_id: 1,
                              county_id: 1,
                              city_id: 1,
                              )
    #same neighborhood
    @address2 = Address.create(address_line1: "245 Second Address", zipcode_id: 1,
                              neighborhood_id: 1,
                              county_id: 1,
                              city_id: 1,
                              )
    #different neighborhood, same city
    @address3 = Address.create(address_line1: "678 Third Address", zipcode_id: 1,
                              neighborhood_id: 2,
                              county_id: 1,
                              city_id: 1,
                              )
  end
  context "one person signups up to region" do
    it 'and region score does not reflect personal average of zero' do
      user = User.create(first: 'D', last: "Simpson", email: "d.simpson@gmail.com",
                        password: 'password', generation: 1)
      house = House.create(address_id: 1, no_residents: 1, total_sq_ft: 3000)
      @neighborhood.update_data
      @neighborhood2.update_data
      n1_avg = @neighborhood.avg_daily_electricity_consumed_per_user
      n2_avg = @neighborhood2.avg_daily_electricity_consumed_per_user
      u_avg = user.avg_daily_electricity_consumption
      expect(n1_avg).to eq(0)
      expect(n2_avg).to eq(0)
      expect(u_avg.nan?).to be true
    end
    it 'and affects entire score with first bill' do

    end
    it 'and affects entire score with second bill' do

    end
  end
  context "two people within area affects entire score" do

  end
end
