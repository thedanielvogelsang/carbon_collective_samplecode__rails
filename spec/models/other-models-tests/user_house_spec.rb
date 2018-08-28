require 'rails_helper'

RSpec.describe UserHouse, type: :model do
  before(:each) do
    country = Country.create(name: "Country-land")
    region = Region.create(name: "Region-land", country_id: country.id)
    city = City.create(name: "City", region_id: region.id)
    neighborhood = Neighborhood.create(name: "My Neighborhood", city_id: city.id)
    zip = Zipcode.create(zipcode: 80291)
    address = Address.create(address_line1: "123 My Address", zipcode_id: zip.id,
                              neighborhood_id: neighborhood.id,
                              city_id: city.id,
                              )
    @user = User.create(first: 'R', last: "Rajan", email: "r.rajan@gmail.com",
                        password: 'password', generation: 1)
    @house = House.create(address_id: address.id, no_residents: 1, total_sq_ft: 3000)
  end
  context 'before and after creation methods' do
    it 'adds a resident to a house upon creation' do
        expect(@house.no_residents).to eq(1)

      uh = UserHouse.create(house_id: @house.id, user_id: @user.id)
        expect(House.last.id).to eq(@house.id)
        expect(House.last.no_residents).to eq(2)
    end
    it 'takes away a resident to a house upon deletion' do
      uh = UserHouse.create(house_id: @house.id, user_id: @user.id)
      house = House.last
          expect(house.no_residents).to eq(2)

      uh.destroy
      house = House.last
        expect(house.no_residents).to eq(1)
    end
  end
end
