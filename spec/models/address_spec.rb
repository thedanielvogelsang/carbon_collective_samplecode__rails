require 'rails_helper'

RSpec.describe Address, type: :model do
  context 'valid address creation' do
    before(:each) do
      Zipcode.create(zipcode: "0")
      @zip = Zipcode.create(zipcode: 80212)
      @zip2= Zipcode.create(zipcode: "11100")
      @addy = "123 Main St"
      @city = "Denver"
      @country = "United States of America"
      @addy2 = "4100 Albion St"
      @city2 = "Fort Collins"
      @country2 = "Canada"
      @n1 = "Neighborhood 1"
      @n2 = "Neighborhood 2"
    end
    xit 'can be created with simply address, city, and country with or without zipcode_id and/or neighborhood_id' do

      address = Address.new(address_line1: @addy,
                            city: @city,
                            country: @country,
                            )

      expect(City.count).to eq(0)
      expect(Country.count).to eq(0)
      expect(Address.count).to eq(0)
      expect(address.save).to be true

      expect(address.zipcode.zipcode).to eq("0")
      expect(address.country).to eq("United States of America")
      expect(address.city).to eq("Denver")
      expect(address.state).to eq("United States of America Region")
      expect(address.address_line1).to eq("123 Main St")
      expect(address.neighborhood.name).to eq("0 Zip Area")
      expect(City.count).to eq(1)
      expect(Country.count).to eq(1)
      expect(Neighborhood.count).to eq(1)
      expect(Address.count).to eq(1)

      address.zipcode_id = @zip.id
      expect(address.neighborhood.name).to eq("0 Zip Area")
      expect(address.save).to be true
      # can't change neighborhoods with zip update
      expect(address.zipcode.zipcode).to eq("80212")
      expect(address.neighborhood.name).to eq("0 Zip Area")
    end
    xit 'can share a city and not a zip' do
      address = Address.new(address_line1: @addy, city: @city, country: @country, zipcode_id: @zip.id)
      expect(address.country).to eq("United States of America")
      address2 = Address.new(address_line1: @addy2, city: @city, country: @country, zipcode_id: @zip2.id)
      expect(address.save).to be true
      expect(address2.save).to be true
      expect(address.zipcode).to_not eq(address2.zipcode)
      expect(address.city).to eq(address2.city)
      expect(address.country).to eq(address2.country)
    end
    xit 'can share a neighborhood and not a zip' do
      address = Address.new(address_line1: @addy, city: @city, country: @country, neighborhood_name: @n1, zipcode_id: @zip.id)
      expect(address.country).to eq("United States of America")
      address2 = Address.new(address_line1: @addy2, city: @city, country: @country, neighborhood_name: @n1, zipcode_id: @zip2.id)
      expect(address.save).to be true
      expect(address2.save).to be true
      expect(address.zipcode).to_not eq(address2.zipcode)
      expect(address.neighborhood).to eq(address2.neighborhood)
    end
    xit 'can share a zip and not a neighborhood' do
      address = Address.new(address_line1: @addy, city: @city, country: @country, neighborhood_name: @n1, zipcode_id: @zip.id)
      expect(address.country).to eq("United States of America")
      address2 = Address.new(address_line1: @addy2, city: @city, country: @country, neighborhood_name: @n2, zipcode_id: @zip.id)
      expect(address.save).to be true
      expect(address2.save).to be true
      expect(address.zipcode).to eq(address2.zipcode)
      expect(address.neighborhood).to_not eq(address2.neighborhood)
    end
  end
  context 'regional associations' do
    before(:each) do
      Zipcode.create(zipcode: "0")
      @zip1 = Zipcode.create(zipcode: 80212)
      @zip2= Zipcode.create(zipcode: "11100")
      @addy = "123 Main St"
      @city = "Denver"
      @country = "United States of America"
      @addy2 = "4100 Albion St"
      @city2 = "Fort Collins"
      @country2 = "Canada"
      @n1 = "Neighborhood 1"
      @n2 = "Neighborhood 2"
    end
    xit 'can share associations with another from a different neighborhood' do
      address1 =  Address.create(address_line1: @addy,
                              city: @city,
                              country: @country,
                              neighborhood_name: @n1,
                              zipcode_id: @zip1.id
                              )
      address2 =  Address.create(address_line1: @addy2,
                              city: @city,
                              country: @country,
                              neighborhood_name: @n2,
                              zipcode_id: @zip2.id
                              )
      # calls same city name
      expect(address1.city).to eq(address2.city)
      # calls different neighborhood association
      expect(address1.neighborhood).to_not eq(address2.neighborhood)
      # calls same city association
      expect(address1.neighborhood.city).to eq(address2.neighborhood.city)
      # calls same state name
      expect(address1.state).to eq("United States of America Region")
      expect(address2.state).to eq("United States of America Region")
      # calls same region association
      expect(address1.neighborhood.city.region.name).to eq("United States of America Region")
      expect(address1.neighborhood.city.region).to eq(address2.neighborhood.city.region)
      # calls same country name
      expect(address1.country).to eq(address2.country)
      # calls same country association
      expect(address1.neighborhood.city.region.country).to eq(address2.neighborhood.city.region.country)
    end
    xit 'can share associations with another from a different city' do
      address1 =  Address.create(address_line1: @addy,
                              city: @city,
                              country: @country,
                              neighborhood_name: @n1,
                              zipcode_id: @zip1.id
                              )
      address2 =  Address.create(address_line1: @addy2,
                              city: @city2,
                              country: @country,
                              neighborhood_name: @n1,
                              zipcode_id: @zip2.id
                              )
      # calls different neighborhood association
      expect(address1.neighborhood).to_not eq(address2.neighborhood)
      # calls different city name
      expect(address1.city).to_not eq(address2.city)
      # calls differnet city association
      expect(address1.neighborhood.city).to_not eq(address2.neighborhood.city)
      # calls same "state" name
      expect(address1.state).to eq("United States of America Region")
      expect(address2.state).to eq("United States of America Region")
      # calls same region association
      expect(address1.neighborhood.city.region).to eq(address2.neighborhood.city.region)
      # calls same country name
      expect(address1.country).to eq(address2.country)
      # calls same country association
      expect(address1.neighborhood.city.region.country).to eq(address2.neighborhood.city.region.country)
    end
    xit 'can share associations with another from a different region' do
      2.times do |t|
        Country.create(name: "USA#{t}")
        Region.create(name: "Region#{t}", country_id: Country.last.id)
      end
      address1 =  Address.create(address_line1: @addy,
                              city: @city,
                              country: @country,
                              neighborhood_name: @n1,
                              zipcode_id: @zip1.id
                              )
      address2 =  Address.create(address_line1: @addy,
                              city: @city2,
                              country: @country,
                              state: Region.last.name,
                              neighborhood_name: @n1,
                              zipcode_id: @zip2.id
                              )
      expect(Neighborhood.count).to eq(2)
      ## DIFFERENT NEIGHBORHOOD & CITY
      # calls different neighborhood association
      expect(address1.neighborhood).to_not eq(address2.neighborhood)
      # calls different city name
      expect(address1.city).to_not eq(address2.city)
      # calls differnet city association
      expect(address1.neighborhood.city).to_not eq(address2.neighborhood.city)

      ## SAME REGION, (state name), AND COUNTRY
      # calls same "state" name
      expect(address1.state).to eq("United States of America Region")
      expect(address2.state).to eq("United States of America Region")
      # calls same region association
      expect(address1.neighborhood.city.region).to eq(address2.neighborhood.city.region)
      # calls same country name
      expect(address1.country).to eq(address2.country)
      # calls same country association
      expect(address1.neighborhood.city.region.country).to eq(address2.neighborhood.city.region.country)

    end
    xit 'CANNOT share associations with another from a different country' do
      2.times do |t|
        Country.create(name: "USA#{t}")
        Region.create(name: "Region#{t}", country_id: Country.last.id)
      end
      address1 =  Address.create(address_line1: @addy,
                              city: @city,
                              country: Country.first.name,
                              state: Region.last.name,
                              neighborhood_name: @n1,
                              zipcode_id: @zip1.id
                              )
      address2 =  Address.create(address_line1: @addy,
                              city: @city,
                              country: Country.second.name,
                              state: Region.last.name,
                              neighborhood_name: @n1,
                              zipcode_id: @zip2.id
                              )
      # creating address creates neighborhood
      expect(Country.count).to eq(2)
      expect(address1.state).to eq(address2.state)
      expect(address1.neighborhood.city.region).to_not eq(address2.neighborhood.city.region)
      expect(address1.country).to_not eq(address2.country)
      expect(address1.neighborhood.city.region.country).to_not eq(address2.neighborhood.city.region.country)
    end
  end
  context 'region creations' do
    before(:each) do
      Zipcode.create(zipcode: "0")
      @zip1 = Zipcode.create(zipcode: 80212)
      @zip2= Zipcode.create(zipcode: "11100")
      @addy = "123 Main St"
      @city = "Denver"
      @country = "United States of America"
      @addy2 = "4100 Albion St"
      @city2 = "Fort Collins"
      @country2 = "Canada"
      @n1 = "Neighborhood 1"
      @n2 = "Neighborhood 2"
    end
    xit "creates a neighborhood and region if given name but no id" do
      expect(Neighborhood.count).to eq(0)
      expect(Region.count).to eq(0)
      address1 =  Address.create(address_line1: @addy,
                              city: @city,
                              country: @country,
                              neighborhood_name: @n1,
                              zipcode_id: @zip1.id
                              )
      expect(Neighborhood.count).to eq(1)
      expect(Neighborhood.first.name).to eq(@n1)
      expect(Region.count).to eq(1)
    end
    xit "creates a neighborhood based on zip and region based on country if given neither" do
      expect(Neighborhood.count).to eq(0)
      expect(Region.count).to eq(0)
      address =  Address.create(address_line1: @addy,
                              city: @city,
                              country: @country,
                              zipcode_id: @zip1.id
                              )
      expect(Neighborhood.count).to eq(1)
      name = Neighborhood.first.name
      expect(address.neighborhood.name).to eq(name)
      #names neighborhood based on zip in absence of neighborhood_name
      expect(name).to eq(@zip1.zipcode + " Zip Area")
      expect(Region.count).to eq(1)
      r_name = Region.first.name
      #names neighborhood based on country in absence of state_name
      expect(r_name).to eq(@country + " Region")
      expect(address.state).to eq(r_name)
      expect(address.neighborhood.city.region.name).to eq(r_name)
    end
  end
  context 'multiple addresses across a city' do
    before(:each) do
      @country = Country.create(name: "United States of America")
      @state = Region.create(name: "Colorado", country_id: @country.id)

      @city = "Denver"
      city2 = "Fort Collins"
      city3 = "Golden"
      @zip1 = "80216"
      zip2 = "80218"
      zip3 = "80211"
      zip_fort = "80521"
      zip_gold = "80401"

      @neighborhood1 = "Cap Hill"
      neighborhood2 = "Five Points"
      neighborhood3 = "Highlands"
    end
    it 'can create 2 houses that share all regions' do
      z = Zipcode.create(zipcode: @zip1)
        add1 = Address.create!(address_line1: "1255 Emerson St", address_line2: "#2",
                    city: @city, country: @country, state: @state,
                    neighborhood_name: @neighborhood1,
                    zipcode_id: z.id)

        add2 = Address.create!(address_line1: "1234 Race St",
                  city: @city, country: @country, state: @state,
                  neighborhood_name: @neighborhood1,
                  zipcode_id: z.id)
        expect(add1.neighborhood).to eq(add2.neighborhood)
        expect(add1.neighborhood.city).to eq(add2.neighborhood.city)
        expect(add1.neighborhood.city.region).to eq(add2.neighborhood.city.region)
        expect(add1.neighborhood.city.region.country).to eq(add2.neighborhood.city.region.country)
    end
  end
end
