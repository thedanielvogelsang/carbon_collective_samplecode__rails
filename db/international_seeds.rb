#Funky foreign addresses with zipcode
#house 1
#3904 guaranteed savings; more on first bill

Zipcode.create(zipcode: "1500")
pretoria = Address.create(address_line1: "497 Jacob Mare Street",
               city: "Pretoria",
               country: "South Africa",
               zipcode_id: Zipcode.last.id)

        house = House.create(total_sq_ft: rand(1000..3000), no_residents: 1, address_id: pretoria.id)

        bind_new_user(house)
        puts "#{house} added in #{pretoria.country}"
          kwhs = 1000
          price = rand(1..100)
          bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
        puts "bill added to house ##{house.id} in #{house.address.city}: #{bill}"
          kwhs2 = 3900
          price2 = rand(1..100)
          sdate = @start_date - 30
          edate = @end_date - 30
          bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id)
        puts "second bill added to house ##{house.id} in #{house.address.city}: #{bill2}\n"

# house 2
#7098
Zipcode.create(zipcode: "1000")
bruxelles = Address.create(address_line1: "Place de la Bourse 3",
               city: "Bruxelles",
               country: "Belgium",
               zipcode_id: Zipcode.last.id)

        house = House.create(total_sq_ft: rand(1000..3000), no_residents: 2, address_id: bruxelles.id)
        bind_new_user(house)
        bind_new_user(house)
        puts "#{house} added in #{bruxelles.country}"
          kwhs = 6800
          price = rand(1..100)
          bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
        puts "bill added to house ##{house.id} in #{house.address.city}: #{bill}"
          kwhs2 = 7200
          price2 = rand(1..1000)
          sdate = @start_date - 30
          edate = @end_date - 30
          bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id)
        puts "second bill added to house ##{house.id} in #{house.address.city}: #{bill2}\n"

# house 3
#6448 -- averages above with no savings unless no_residents > 3
Zipcode.create(zipcode: "11100")
narbonne = Address.create(address_line1: "3 voie du Silène",
               city: "Narbonne",
               country: "France",
               zipcode_id: Zipcode.last.id)

        house = House.create(total_sq_ft: rand(1000..3000), no_residents: rand(1..6), address_id: narbonne.id)
        bind_new_user(house)
        puts "#{house} added in #{narbonne.country}"
          kwhs = 20000
          price = rand(1..1000)
          bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
        puts "1 bill added to house ##{house.id} in #{house.address.city}: #{bill}\n"

# 15055 no savings
Zipcode.create(zipcode: "00974")
doha_qatar = Address.create(address_line1: "Airport Road Al Matar St",
               city: "Doha",
               country: "Qatar",
               zipcode_id: Zipcode.last.id)

        house = House.create(total_sq_ft: rand(1000..3000), no_residents: 1, address_id: doha_qatar.id)
        bind_new_user(house)
        puts "#{house} added in #{doha_qatar.country}"
          kwhs = 35000
          price = rand(1..1000)
          bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
        puts "1 bill added to house ##{house.id} in #{house.address.city}: #{bill}\n"

# 861 no savings unless house.no_residents > 2
Zipcode.create(zipcode: "2000")
casablanca = Address.create(address_line1: "3036 20000 Boulevard de l'Océan Atlantique",
                city: "Casablanca",
                country: "Morocco",
                zipcode_id: Zipcode.last.id)

          house = House.create(total_sq_ft: rand(1000..3000), no_residents: rand(1..6), address_id: casablanca.id)
          bind_new_user(house)
          puts "#{house} added in #{casablanca.country}"
            kwhs = 2000
            price = rand(1..100)
            bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
          puts "1 bill added to house ##{house.id} in #{house.address.city}: #{bill}"

# Funky Foreign Addresses without zipcodes
# 38 guaranteed savings
zip = Zipcode.create(zipcode: "0")
kigali = Address.create(address_line1: "KN 14 Avenue",
                        city: "Kigali",
                        neighborhood_name: "Kimihurura",
                        country: "Rwanda",
                        zipcode_id: zip.id)

                  house = House.create(total_sq_ft: rand(1000..3000), no_residents: rand(1..6), address_id: kigali.id)
                  user = bind_new_user(house)
                  puts "#{house} added in #{kigali.country} to #{user.first}"
                    kwhs = rand(10..30)
                    price = rand(1..10)/4
                    bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
                  puts "1 bill added to house ##{house.id} in #{house.address.city}: #{bill}"
# ## ------
# # creates 2 users in kenya, and one in each other country
# 162
zipx = Zipcode.find_or_create_by(zipcode: "101")

nairobi = Address.create(address_line1: "320 Ngong Rd",
                        city: "Nairobi",
                        country: "Kenya",
                        zipcode_id: zipx.id)

nairobi2 = Address.create(address_line1: "322 Ngong Rd",
                        city: "Nairobi",
                        country: "Kenya",
                        zipcode_id: zipx.id)
    house = House.create(total_sq_ft: rand(1000..3000), no_residents: 4, address_id: nairobi.id)
    bind_new_user(house)
    puts "1st house (id: #{house.id}) added in Kenya"
      kwhs = 180
      price = rand(1..10)/4
      bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
    puts "1 bill added to house ##{house.id} in #{house.address.city}: #{bill}"

    house2 = House.create(total_sq_ft: rand(1000..3000), no_residents: 3, address_id: nairobi2.id)
    bind_new_user(house2)

    puts "2nd house (id: #{house2.id}) added in #{nairobi.country}"
      kwhs = 99
      price = 10
      bill1 = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house2.id)

      sdate = @start_date - 30
      edate = @end_date - 30
      kwhs = 199
      price = 28
      bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs, price: price, house_id: house2.id)
    puts "2 bill added to house ##{house.id} in #{house.address.city}. IDs: #{bill1.id}, #{bill2.id}"

puts "\n"
puts "\n"
country_names = Address.all.map{|a| a.country}
puts "#{Address.count} addresses created in foreign countries #{country_names}"
puts "#{House.count} houses made with #{ElectricBill.count} bills logged"
puts "2 houses in Kenya, 1 per every other country"
puts "\n"
puts "\n"
