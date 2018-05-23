# At this point, integers represent annual average electricity use
#        per household for each region; pending addition of water and gas
require 'csv'

COUNTRIES = {
  :countries => [
  ["Afghanistan", 141],
  ["Albania", 2564],
  ["Algeria", 1216],
  ["American Samoa", 1845],
  ["Andorra", 6565],
  ["Angola", 401],
  ["Antigua & Barbuda", 3205],
  ["Argentina", 2643],
  ["Armenia", 1671],
  ["Aruba", 7039],
  ["Australia", 9742],
  ["Austria", 8006],
  ["Azerbaijan", 2025],
  ["Bahamas", 4888],
  ["Bahraim", 18130],
  ["Bangladesh", 351],
  ["Barbados", 3087],
  ["Belarus", 3448],
  ["Belgium", 7099],
  ["Belize", 1130],
  ["Benin", 93],
  ["Bermuda", 8505],
  ["Bhutan", 2779],
  ["Bolivia", 683],
  ["Bosnia & Herzegovina", 2848],
  ["Botswana", 1674],
  ["Brazil", 2516],
  ["Brunei Darussalam", 8625],
  ["Bulgaria", 4338],
  ["Burkina Faso", 61],
  ["Myanmar/Burma", 193],
  ["Burundi", 36],
  ["Cambodia", 256],
  ["Cameroon", 250],
  ["Canada", 14930],
  ["Cape Verde (Cabo Verde)", 542],
  ["Cayman Islands", 10477],
  ["Central African Republic", 36],
  ["Chad", 16],
  ["Chile", 3739],
  ["China", 2674],
  ["Colombia", 1270],
  ["Comoros", 51],
  ["Congo, Republic of the", 185],
  ["Cook Islands", 3308],
  ["Costa Rica", 1888],
  ["Croatia", 3933],
  ["Cuba", 597],
  ["Curaçao", 6495],
  ["Cyprus", 3234],
  ["Czech Republic", 5636],
  ["Democratic Republic of the Congo", 114],
  ["Denmark", 5720],
  ["Djibouti", 472],
  ["Dominican Republic", 1427],
  ["Dominica", 1223],
  ["Ecuador", 1305],
  ["Egypt", 1510],
  ["El Salvador", 925],
  ["Equatorial Guinea", 120],
  ["Eritrea", 51],
  ["Estonia", 6515],
  ["Ethiopia", 65],
  ["Falkland Islands", 4759],
  ["Fiji", 874],
  ["Finland", 14732],
  ["France", 6448],
  ["French Polynesia", 2453],
  ["Gabon", 1207],
  ["Gambia", 149],
  ["Gaza Strip", 0.1],
  ["Georgia", 1988],
  ["Germany", 6602],
  ["Gibraltar", 6819],
  ["Ghana", 341],
  ["Greece", 4919],
  ["Greenland", 5196],
  ["Grenada", 1798],
  ["Guam", 9217],
  ["Guatemala", 586],
  ["Guinea", 74],
  ["Guinea-Bissau", 17],
  ["Guyana", 1087],
  ["Haiti", 38],
  ["Honduras", 595],
  ["Hong Kong", 5859],
  ["Hungary", 2182],
  ["Iceland", 50613],
  ["India", 1122],
  ["Indonesia", 754],
  ["Iran", 2632],
  ["Iraq", 1101],
  ["Ireland", 5047],
  ["Israel", 7319],
  ["Italy", 4692],
  ["Ivory Coast (Cote d'Ivoire)", 244],
  ["Jamaica", 942],
  ["Japan", 7371],
  ["Jordan", 1954],
  ["Kazakhstan", 4956],
  ["Kenya", 162],
  ["Kiribati", 260],
  ["Kosovo", 1533],
  ["Kuwait", 19062],
  ["Kyrgyz Republic (Kyrgyzstan)", 1920],
  ["Laos", 555],
  ["Latvia", 3459],
  ["Lebanon", 2565],
  ["Lesotho", 409],
  ["Liberia", 69],
  ["Libya", 1421],
  ["Liechtenstein", 35848],
  ["Lithuania", 3468],
  ["Luxembourg", 10647],
  ["Macau", 7532],
  ["Republic of Macedonia", 3314],
  ["Madagascar", 53],
  ["Malawi", 102],
  ["Malaysia", 4232],
  ["Maldives", 763],
  ["Mali", 80],
  ["Malta", 4817],
  ["Marshall Islands", 8177],
  ["Mauritania", 217],
  ["Mauritius", 1928],
  ["Mexico", 1932],
  ["Moldova, Republic of", 1226],
  ["Mongolia", 1847],
  ["Montenegro", 4343],
  ["Montserrat", 4061],
  ["Morocco", 861],
  ["Mozambique", 462],
  ["Namibia", 1518],
  ["Nauru", 2424],
  ["Nepal", 134],
  ["Netherlands", 6346],
  ["New Zealand", 8939],
  ["Nicaragua", 739],
  ["Niger", 64],
  ["Nigeria", 128],
  ["Korea, Democratic Republic of (North Korea)", 1347],
  ["Norway", 24006],
  ["Oman", 7450],
  ["Pakistan", 405],
  ["Panama", 2105],
  ["Papua New Guinea", 441],
  ["Paraguay", 1413],
  ["Peru", 1268],
  ["Philippines", 885],
  ["Poland", 3686],
  ["Portugal", 4245],
  ["Puerto Rico", 5310],
  ["Qatar", 15055],
  ["Romania", 2222],
  ["Russian Federation", 7481],
  ["Rwanda", 38],
  ["Saint Kitts and Nevis", 3821],
  ["Saint Lucia", 1824],
  ["Saint Vincent's & Grenadines", 977],
  ["Samoa", 502],
  ["Sao Tome and Principe", 329],
  ["Saudi Arabia", 9658],
  ["Senegal", 209],
  ["Serbia", 3766],
  ["Seychelles", 3219],
  ["Sierra Leone", 33],
  ["Singapore", 8160],
  ["Slovak Republic (Slovakia)", 5207],
  ["Slovenia", 6572],
  ["Solomon Islands", 124],
  ["Somalia", 27],
  ["South Africa", 3904],
  ["Korea, Republic of (South Korea)", 9720],
  ["South Sudan", 55],
  ["Spain", 4818],
  ["Sri Lanka", 494],
  ["Sudan", 269],
  ["Suriname", 3243],
  ["Swaziland", 1033],
  ["Sweden", 12853],
  ["Switzerland", 7091],
  ["Syria", 989],
  ["Tajikistan", 1440],
  ["Tanzania", 95],
  ["Thailand", 2404],
  ["Taiwan", 10632],
  ["Timor Leste", 99],
  ["Togo", 141],
  ["Tonga", 436],
  ["Trinidad & Tobago", 7456],
  ["Tunisia", 1341],
  ["Turkey", 2578],
  ["Turkmenistan", 2456],
  ["Turks & Caicos Islands", 3888],
  ["Uganda", 70],
  ["Ukraine", 3234],
  ["United Arab Emirates", 16195],
  ["United Kingdom (Great Britain)", 4796],
  ["United States of America", 12071],
  ["Uruguay", 2984],
  ["Uzbekistan", 1628],
  ["Vanuatu", 201],
  ["Venezuela", 2532],
  ["Vietnam", 1312],
  ["Virgin Islands (UK)", 2921],
  ["Virgin Islands (US)", 5828],
  ["West Bank", 1927],
  ["Yemen", 189],
  ["Zambia", 709],
  ["Zimbabwe", 549],
  ]
}

GLOBE = Global.create

COUNTRIES[:countries].each do |c|
  edaily_avg = c[1].fdiv(30)
  wdaily_avg = 101.5
  Country.create!(name: c[0], avg_daily_electricity_consumed_per_capita: edaily_avg,
                  avg_daily_electricity_consumed_per_user: edaily_avg,
                  avg_daily_water_consumed_per_capita: wdaily_avg,
                  avg_daily_water_consumed_per_user: wdaily_avg,
                  )
end

usa = Country.find(199)
usa.avg_daily_gas_consumed_per_capita = 8.46
usa.avg_daily_gas_consumed_per_user = 8.46
usa.save

puts "You have #{Country.count} countries in the database"

# All states have electric, water, and gas averages
STATES = [
  ["Alabama", 1211, 82, 10.92],
  ["Alaska", 632, 94, 23.33],
  ["Arizona", 1049, 142, 5.86],
  ["Arkansas", 1133, 100, 9.83],
  ["California", 557, 126, 5.47],
  ["Colorado", 723, 123, 7.56],
  ["Connecticut", 752, 77, 5.83],
  ["Delaware", 944, 63, 8.17],
  ["Florida", 1078, 98, 5.83],
  ["Georgia", 1088, 95, 7.78],
  ["Hawaii", 515, 169, 5.50],
  ["Idaho", 1055, 187, 8.81],
  ["Illinois", 755, 92, 8.53],
  ["Indiana", 1005, 78, 11.94],
  ["Iowa", 908, 67, 13.31],
  ["Kansas", 926, 83, 10.53],
  ["Kentucky", 1154, 69, 10.83],
  ["Louisiana", 1273, 119, 25.33],
  ["Maine", 551, 56, 8.47],
  ["Maryland", 1031, 111, 6.57],
  ["Massachusetts", 632, 84, 5.92],
  ["Michigan", 665, 82, 7.75],
  ["Minnesota", 817, 70, 8.97],
  ["Mississippi", 1220, 118, 10.53],
  ["Missouri", 1086, 90, 8.36],
  ["Montana", 860, 114, 10.53],
  ["Nebraska", 1034, 137, 12.50],
  ["Nevada", 924, 192, 6.25],
  ["New Hampshire", 629, 77, 6.36],
  ["New Jersey", 687, 71, 7.11],
  ["New Mexico", 655, 109, 9.31],
  ["New York", 602, 99, 5.25],
  ["North Carolina", 1098, 72, 6.97],
  ["North Dakota", 1205, 93, 22.31],
  ["Ohio", 892, 71, 8.94],
  ["Oklahoma", 1142, 87, 11.58],
  ["Oregon", 976, 123, 6.61],
  ["Pennsylvania", 857, 59, 8.42],
  ["Rhode Island", 602, 81, 5.33],
  ["South Carolina", 1124, 102, 9.36],
  ["South Dakota", 1055, 96, 12.42],
  ["Tennessee", 1245, 82, 9.14],
  ["Texas", 1174, 139, 13.06],
  ["Utah", 798, 188, 7.33],
  ["Vermont", 569, 66, 5.86],
  ["Virginia", 1156, 77, 7.86],
  ["Washington", 1041, 105, 7.72],
  ["West Virginia", 1118, 103, 11.69],
  ["Wisconsin", 703, 59, 8.56],
  ["Wyoming", 894, 154, 24.81]
]
CANADA_REGIONS = [
  "Ontario",
  "Quebec",
  "Nova Scotia",
  "New Brunswick",
  "Manitoba",
  "British Colombia",
  "Prince Edward Island",
  "Saskatchewan",
  "Alberta",
  "Newfoundland",
  "Labrador",
]

STATES.each do |r|
  state_avg = "%0.6f" % (("%0.6f" % r[1]).to_f / ("%0.6f" % 30).to_f)
  Region.create(name: r[0], avg_daily_electricity_consumed_per_capita: state_avg,
                avg_daily_water_consumed_per_capita: r[2],
                avg_daily_gas_consumed_per_capita: r[3],
                country_id: Country.find_by(name: "United States of America").id,
               )
end
puts "#{Region.count} States created in Regions table"

#
CANADA_REGIONS.each do |r|
  Region.create(name: r, country_id: Country.find_by(name: "Canada").id)
end
puts "#{Region.count} Provinces created in Regions table"

def bind_new_user(house)
  user = User.new(email: Faker::Internet.email,
                  password: 'banana',
                  first: Faker::Name.first_name,
                  last: Faker::Name.last_name,
                  )
  user.houses << house
  user.save
  puts "#{user} (with id: #{user.id}) created at #{house.address}"
  user
end
@start_date = DateTime.now - 30
@end_date = DateTime.now

# Creates multiple addresses in colorado
country = Country.find_by(name: "United States of America")
state = Region.find_by(name: "Colorado")

city1 = City.create(name: "Denver", region_id: state.id)

zip1 = "80218"
zip2 = "80202"
zip3 = "80211"
zip4 = "80203"
zip5 = "80216"

DENVER_NEIGHBORHOODS = 'db/statistical_neighborhoods.csv'

neighborhood1 = "Capitol Hill"
neighborhood2 = "Five Points"
neighborhood3 = "Highland"

dn1 = Neighborhood.create(name: neighborhood1, city_id: city1.id)
dn2 = Neighborhood.create(name: neighborhood2, city_id: city1.id)
dn3 = Neighborhood.create(name: neighborhood3, city_id: city1.id)

denver_neighborhoods = CSV.open DENVER_NEIGHBORHOODS, headers: true, header_converters: :symbol

denver_neighborhoods.each do |row|
  Neighborhood.create(name: row[:nbhd_name], city_id: city1.id)
end
puts "all neighborhoods of Denver added"
# 5 addresses in Denver; Colorado AVG: 723kwhs/month
  # 3 in caphill -- 2 with zip1, 1 with zip2
    z = Zipcode.create(zipcode: zip1)
      tadd = Address.create(address_line1: "1255 Emerson St", address_line2: "#2",
                  neighborhood_id: dn1.id, city_id: city1.id,
                  zipcode_id: z.id)

    #HOUSE NUMBER 1; 2 resident users; savings in 3/4 bills;
          house = House.create(total_sq_ft: rand(1000..3000), no_residents: 2, address_id: tadd.id)
          user1 = bind_new_user(house)
          user2 = bind_new_user(house)
          puts "#{user1.first} created with email #{user1.email} & password #{user1.password}"
          puts "#{user2.first} created with email #{user2.email} & password #{user1.password}"

              puts "#{house} added in #{tadd.city} at #{tadd.address_line1} in #{tadd.neighborhood.name}"
                kwhs = 1400
                price = rand(1..100)
                bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
              puts "bill added to house ##{house.id} in #{house.address.city.name}: #{bill}"
                kwhs2 = 1200
                price2 = rand(1..100)
                sdate = @start_date - 30
                edate = @end_date - 30
                bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id)
              puts "second bill added to house ##{house.id} in #{house.address.city.name}: #{bill2}"
                kwhs3 = 1000
                price3 = rand(1..100)
                sdate3 = @start_date - 60
                edate3 = @end_date - 60
                bill3 = ElectricBill.create(start_date: sdate3, end_date: edate3, total_kwhs: kwhs3, price: price3, house_id: house.id)
              puts "third bill added to house ##{house.id} in #{house.address.city.name}: #{bill3}"
                kwhs4 = 2000
                price4 = rand(1..100)
                sdate4 = @start_date - 90
                edate4 = @end_date - 90
                bill4 = ElectricBill.create(start_date: sdate4, end_date: edate4, total_kwhs: kwhs4, price: price4, house_id: house.id)
              puts "fourth bill added to house ##{house.id} in #{house.address.city.name}: #{bill4}"

    sadd = Address.create!(address_line1: "1284 Race St",
                neighborhood: dn1, city: city1,
                zipcode_id: z.id)

    # HOUSE NUMBER 2; 5 residents, 3 users; Colorado: 723; savings in 5/5 bills
        house2 = House.create!(total_sq_ft: rand(1000..3000), no_residents: 5, address_id: sadd.id)
        puts "#{house2} added in #{sadd.region} at #{sadd.address_line1} in #{sadd.neighborhood.name}"
        user =  bind_new_user(house2)
        user2 =  bind_new_user(house2)
        user3 =  bind_new_user(house2)
        puts "#{user.first} created with email #{user.email} & password #{user.password}"
        puts "#{user2.first} created with email #{user2.email} & password #{user2.password}"
        puts "#{user3.first} created with email #{user3.email} & password #{user3.password}"

              kwhs = rand(1000..3000)
              price = rand(1..100)
              ebill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house2.id)
              wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 12000, price: price, house_id: house2.id)
            puts "2 bills added to house ##{house2.id} in #{house2.address.city}: #{ebill}, #{wbill}"
              kwhs2 = rand(1000..3000)
              price2 = rand(1..100)
              sdate = @start_date - 30
              edate = @end_date - 30
              bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house2.id)
              wbill2 = WaterBill.create(start_date: sdate, end_date: edate, total_gallons: 15000, price: price, house_id: house2.id)

            puts "second bill added to house ##{house2.id} in #{house2.address.city}: #{bill2}, #{wbill2}"
              kwhs2 = rand(1000..3000)
              price2 = rand(100..200)
              sdate = @start_date - 60
              edate = @end_date - 60
              bill3 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house2.id)
              wbill3 = WaterBill.create(start_date: sdate, end_date: edate, total_gallons: 14000, price: price2, house_id: house2.id)

            puts "third bill added to house ##{house2.id} in #{house2.address.city}: #{bill3}, #{wbill3}"
              kwhs2 = rand(1000..3000)
              price2 = rand(100..200)
              sdate = @start_date - 90
              edate = @end_date - 90
              bill4 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house2.id)
              wbill4 = WaterBill.create(start_date: sdate, end_date: edate, total_gallons: 13670, price: price2, house_id: house2.id)

            puts "fourth bill added to house ##{house2.id} in #{house2.address.city}: #{bill4}, #{wbill4}"
              kwhs2 = rand(1000..3000)
              price2 = rand(100..200)
              sdate = @start_date - 120
              edate = @end_date - 120
              bill5 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house2.id)
              # no save here suspected
              wbill5 = WaterBill.create(start_date: sdate, end_date: edate, total_gallons: 16670, price: price2, house_id: house2.id)

            puts "fifth bill added to house ##{house2.id} in #{house2.address.city}: #{bill5}, #{wbill5}"

        # HOUSE NUMBER 3 -- 6 residents 1 user;
            # 2 bills added, 3 waterbills,
            gzip= Zipcode.create(zipcode: zip2)
              gold_add = Address.create(address_line1: "747 Vine St",
                          neighborhood: dn1,
                          city: city1,
                          zipcode_id: gzip.id)

                  house = House.create(total_sq_ft: rand(1000..3000), no_residents: 6, address_id: gold_add.id)
                  puts "#{house} added in #{gold_add.city} at #{gold_add.address_line1} in #{gold_add.neighborhood.name}"
                  user = bind_new_user(house)
                  puts "#{user.first} created with email #{user.email} & password #{user.password}"

                        kwhs = rand(1000..3000)
                        price = rand(1..100)
                        bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
                        wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 17830, price: price, house_id: house.id)

                      puts "bill added to house ##{house.id} in #{house.address.city.name}: #{bill}"
                        kwhs2 = rand(1000..3000)
                        price2 = rand(1..100)
                        sdate = @start_date - 30
                        edate = @end_date - 30
                        bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id)
                        wbill2 = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 15000, price: price, house_id: house.id)

                      puts "second set of bills added to house ##{house.id} in #{house.address.city.name}: #{bill2}, #{wbill2}\n"
                      wbill3 = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 20000, price: price, house_id: house.id)
                      puts "third bill added to house ##{house.id} in #{house.address.city.name}: #{wbill3}\n"

                      puts "created #{Address.where(city_id: city1.id).count} address in CapHill\n\n\n"

  # 2 address in fivepoints;
    # 1 bill for first -- unknown savings (random)
    z2 = Zipcode.create(zipcode: zip4)
      fadd = Address.create(address_line1: "1155 Park Ave", address_line2: '#114',
                  neighborhood: dn2, city: city1,
                  zipcode_id: z2.id)

          house = House.create(total_sq_ft: rand(1000..3000), no_residents: rand(1..6), address_id: fadd.id)
          puts "#{house} added in #{fadd.city} at #{fadd.address_line1} in #{fadd.neighborhood.name}"
          user =  bind_new_user(house)
          puts "#{user.first} created with email #{user.email} & password #{user.password}"

              kwhs = rand(10..3000)
              price = rand(1..100)
              bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
              wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 17270, price: price, house_id: house.id)
            puts "1 bill added to house ##{house.id} in #{house.address.city.name}: #{bill}, #{wbill}"

      fort_add = Address.create(address_line1: "125 Main St", address_line2: "#202",
                  city_id: city1.id, neighborhood: Neighborhood.find_by(name: "Five Points"),
                  zipcode_id: z2.id)

    # 3 bill for second -- unknown savings (random)
          house = House.create(total_sq_ft: rand(1000..3000), no_residents: rand(1..6), address_id: fort_add.id)
          puts "#{house} added in #{fort_add.city} at #{fort_add.address_line1} in #{fort_add.region}"
          user = bind_new_user(house)
          puts "#{user.first} created with email #{user.email} & password #{user.password}"

                kwhs = rand(100..3000)
                price = rand(40..100)
                gals = rand(10000..30000)
                bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
                wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: gals, price: price, house_id: house.id)

              puts "bill added to house ##{house.id} in #{house.address.city.name}: #{bill}, #{wbill}"
                kwhs2 = rand(100..3000)
                gals2 = gals.fdiv(2)
                price2 = rand(40..100)
                sdate = @start_date - 30
                edate = @end_date - 30
                bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id)
                wbill2 = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: gals2, price: price, house_id: house.id)

              puts "second bill added to house ##{house.id} in #{house.address.city.name}: #{bill2}, #{wbill2}\n"
                kwhs3 = rand(100..3000)
                price3 = rand(40..100)
                sdate3 = @start_date - 60
                edate3 = @end_date - 60
                gals3 = rand(1000..15000)
                bill3 = ElectricBill.create(start_date: sdate3, end_date: edate3, total_kwhs: kwhs3, price: price3, house_id: house.id)
                wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: gals3, price: price, house_id: house.id)

              puts "third bill added to house ##{house.id} in #{house.address.city.name}: #{bill3}\n"
              puts "created #{Address.where(city: 'Fort Collins').count} address in Fort Collins\n\n\n"

  # 2 addresses in Highlands (same neighborhood) with different zips
  # first house: 4 residents, 2 users; 1 bill, no savings
      gadd = Address.create(address_line1: "4109 32nd St",
                  neighborhood: dn3, city: city1,
                  zipcode_id: z2.id)
          house = House.create(total_sq_ft: 3500, no_residents: 4, address_id: gadd.id)
            puts "#{house} added in #{gadd.city} at #{gadd.address_line1} in #{gadd.neighborhood.name}"

              user1 = bind_new_user(house)
              user2 = bind_new_user(house)

              #2 users in same house:
              puts "2 users linked to #{gadd.address_line1}:"
              puts "#{user1.first} created with email #{user1.email} & password #{user1.password}"
              puts "#{user2.first} created with email #{user2.email} & password #{user2.password}"

              kwhs = 34000
              price = rand(200..300)
              bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
              wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 17270, price: price, house_id: house.id)
            puts "1 bill added to house ##{house.id} in #{house.address.city.name}: #{bill}, #{wbill}\n"

  # second house: 4 residents, 2 users; 1 bill, net savings
    z3 = Zipcode.create(zipcode: zip3)
      dadd = Address.create!(address_line1: "4589 Zuni St",
                neighborhood: dn3, city: city1,
                zipcode_id: z3.id)
            dan = User.create(first: "Daniel", last: "Vog",
                              email: 'dvog@gmail.com',
                              password: 'password')

        house = House.create!(total_sq_ft: rand(1000..3000), no_residents: 4, address_id: dadd.id)
          puts "#{house} added in #{dadd.city} at #{dadd.address_line1} in #{dadd.neighborhood.name}"
        dan.houses << house
          puts "#{dan.first} created with email #{dan.email} & password #{dan.password}, added to house(#{house.id})"
        user2 = bind_new_user(house)
          puts "#{user2.first} created with email #{user2.email} & password #{user2.password}, added to house(#{house.id})"
        kwhs = rand(10..100)
        price = rand(1..100)
        bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
        wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 10000, price: 34.66, house_id: house.id)
          puts "1 bill added to house ##{house.id} in #{house.address.city.name}: #{bill}\n"


# 2 address in random neighborhood at same address
# random everything; no idea how much savings -- WITH NEIGHBORHOOD
  bzip= Zipcode.create(zipcode: 80305)
        rand_add = Address.create(address_line1: "1981 E 18th St", address_line2: "#202",
                    city_id: city1.id, neighborhood: Neighborhood.find(rand(10..18)),
                    zipcode_id: bzip.id)
        # this address is a trial to test for address validations of address_line1 + address_line2
        rand_two = Address.create(address_line1: "1981 E 18th St", address_line2: "#204",
                    city_id: city1.id, neighborhood: rand_add.neighborhood, zipcode_id: bzip.id)

                house2 = House.create(total_sq_ft: 400, no_residents: 2, address_id: rand_two.id)
                bind_new_user(house)
                puts "#{house2} added at #{rand_add.address_line1}, #{rand_add.address_line2} in #{rand_add.neighborhood.name} with no bills"

                house = House.create(total_sq_ft: 600, no_residents: rand(1..6), address_id: rand_add.id)
                puts "#{house} added in #{rand_add.city} at same address, different apartment: #{rand_add.address_line1}, #{rand_add.address_line2}"
                user = bind_new_user(house)
                puts "#{user.first} created with email #{user.email} & password #{user.password}"

                      kwhs = rand(100..3000)
                      price = rand(40..100)
                      gals = rand(1000..40000)
                      bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
                      wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: gals, price: price, house_id: house.id)

                    puts "bill added to house ##{house.id} in #{house.address.city.name}: #{bill}"
                      kwhs2 = rand(100..3000)
                      price2 = rand(40..100)
                      sdate = @start_date - 30
                      edate = @end_date - 30
                      gals = rand(1000..40000)

                      bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id)
                      wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: gals, price: price, house_id: house.id)

                    puts "second bill added to house ##{house.id} in #{house.address.city.name}: #{bill2}\n"
                      kwhs3 = rand(100..3000)
                      price3 = rand(40..100)
                      sdate3 = @start_date - 60
                      edate3 = @end_date - 60
                      gals = rand(1000..40000)

                      bill3 = ElectricBill.create(start_date: sdate3, end_date: edate3, total_kwhs: kwhs3, price: price3, house_id: house.id)
                      wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: gals, price: price, house_id: house.id)

                    puts "third bill added to house ##{house.id} in #{house.address.city.name}: #{bill3}\n"
                    puts "created address in #{house.address.neighborhood.name}\n\n\n"

GLOBE.update_data
Country.all.each{|c| c.set_default_ranks}
country.update_data

Region.all.each{|r| r.set_default_ranks}

state.update_data

User.all.each{|u| u.set_default_ranks}
User.all.each{|u| u.email_activate}

City.all.each do |c|
    c.set_default_ranks
    c.update_data
end

Neighborhood.all.each do |n|
  n.set_default_ranks
  n.update_data
end

# # #
# # # COORD = [
# # #          [[46.3625, 15.114444],[46.055556, 14.508333]],
# # #          [[50.82413,  -104.95922], [50.82413, -104.95922]],
# # #          [[-59.3068, 164.92105], [-58.2200, 164.99910]],
# # #          [[-24.82067, -113.06858],[-25.25919, -116.92851]],
# # #          [[-2.66268, -82.91891], [-8.66172, -162.63773]],
# # #          [[29.98702,  -134.26584], [26.98321, -130.39952]]
# # #        ]
