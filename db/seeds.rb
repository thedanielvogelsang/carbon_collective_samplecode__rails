# At this point, integers represent annual average electricity use
#        per household for each region; pending addition of water and gas
require 'csv'
DENVER_NEIGHBORHOODS = './statistical_neighborhoods.csv'

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
  daily_avg = c[1].fdiv(30)
  Country.create!(name: c[0], avg_daily_electricity_consumed_per_capita: daily_avg)
end
puts "You have #{Country.count} countries in the database"
#
STATES = [
  ["Alabama", 1211],
  ["Alaska", 632],
  ["Arizona", 1049],
  ["Arkansas", 1133],
  ["California", 557],
  ["Colorado", 723],
  ["Connecticut", 752],
  ["Delaware", 944],
  ["Florida", 1078],
  ["Georgia", 1088],
  ["Hawaii", 515],
  ["Idaho", 1055],
  ["Illinois", 755],
  ["Indiana", 1005],
  ["Iowa", 908],
  ["Kansas", 926],
  ["Kentucky", 1154],
  ["Louisiana", 1273],
  ["Maine", 551],
  ["Maryland", 1031],
  ["Massachusetts", 632],
  ["Michigan", 665],
  ["Minnesota", 817],
  ["Mississippi", 1220],
  ["Missouri", 1086],
  ["Montana", 860],
  ["Nebraska", 1034],
  ["Nevada", 924],
  ["New Hampshire", 629],
  ["New Jersey", 687],
  ["New Mexico", 655],
  ["New York", 602],
  ["North Carolina", 1098],
  ["North Dakota", 1205],
  ["Ohio", 892],
  ["Oklahoma", 1142],
  ["Oregon", 976],
  ["Pennsylvania", 857],
  ["Rhode Island", 602],
  ["South Carolina", 1124],
  ["South Dakota", 1055],
  ["Tennessee", 1245],
  ["Texas", 1174],
  ["Utah", 798],
  ["Vermont", 569],
  ["Virginia", 1156],
  ["Washington", 1041],
  ["West Virginia", 1118],
  ["Wisconsin", 703],
  ["Wyoming", 894]
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
  puts "#{user} (with id: #{user.id}) created at #{house.address.address}"
  user
end
@start_date = DateTime.now - 30
@end_date = DateTime.now

# Creates multiple addresses in colorado
country = Country.find_by(name: "United States of America")
state = Region.find_by(name: "Colorado")

city1 = City.create(name: "Denver", region_id: state.id)
city2 = City.create(name: "Fort Collins", region_id: state.id)
city3 = City.create(name: "Golden", region_id: state.id)
city4 = City.create(name: "Boulder", region_id: state.id)

zip1 = "80216"
zip2 = "80218"
zip3 = "80211"
zip_fort = "80521"
zip_gold = "80401"

neighborhood1 = "Capitol Hill"
neighborhood2 = "Five Points"
neighborhood3 = "Highland"

dn1 = Neighborhood.create(name: neighborhood1, city_id: city1.id)
dn2 = Neighborhood.create(name: neighborhood2, city_id: city1.id)
dn3 = Neighborhood.create(name: neighborhood3, city_id: city1.id)

denver_neighborhoods = CSV.open DENVER_NEIGHBORHOODS, headers: true, header_converters: :symbol

denver_neighborhoods.each do |row|
  byebug
  Neighborhood.create(name: row[:name], city_id: city1.id)
end
# 5 addresses in Denver; Colorado AVG: 723kwhs/month
  # 2 in caphill
    z = Zipcode.create(zipcode: zip1)
      tadd = Address.create(address_line1: "1255 Emerson St", address_line2: "#2",
                  neighborhood_id: dn1.id, city_id: city1.id,
                  zipcode_id: z.id)

    #HOUSE NUMBER 9; 2 resident users; savings in 3/4 bills;
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

    # HOUSE NUMBER 10; 5 residents, 3 users; Colorado: 723; savings in 5/5 bills
        house10 = House.create!(total_sq_ft: rand(1000..3000), no_residents: 5, address_id: sadd.id)
        puts "#{house10} added in #{sadd.region} at #{sadd.address_line1} in #{sadd.neighborhood.name}"
        user =  bind_new_user(house10)
        user2 =  bind_new_user(house10)
        user3 =  bind_new_user(house10)
        puts "#{user.first} created with email #{user.email} & password #{user.password}"
        puts "#{user2.first} created with email #{user2.email} & password #{user2.password}"
        puts "#{user3.first} created with email #{user3.email} & password #{user3.password}"

              kwhs = rand(1000..3000)
              price = rand(1..100)
              bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house10.id)
            puts "bill added to house ##{house10.id} in #{house10.address.city}: #{bill}"
              kwhs2 = rand(1000..3000)
              price2 = rand(1..100)
              sdate = @start_date - 30
              edate = @end_date - 30
              bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house10.id)
            puts "second bill added to house ##{house10.id} in #{house10.address.city}: #{bill2}"
              kwhs2 = rand(1000..3000)
              price2 = rand(100..200)
              sdate = @start_date - 60
              edate = @end_date - 60
              bill3 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house10.id)
            puts "third bill added to house ##{house10.id} in #{house10.address.city}: #{bill3}"
              kwhs2 = rand(1000..3000)
              price2 = rand(100..200)
              sdate = @start_date - 90
              edate = @end_date - 90
              bill4 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house10.id)
            puts "fourth bill added to house ##{house10.id} in #{house10.address.city}: #{bill4}"
              kwhs2 = rand(1000..3000)
              price2 = rand(100..200)
              sdate = @start_date - 120
              edate = @end_date - 120
              bill5 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house10.id)
            puts "fifth bill added to house ##{house10.id} in #{house10.address.city}: #{bill5}"

  # 1 address in fivepoints; 1 bill; unknown savings (random)
    z2 = Zipcode.create(zipcode: zip2)
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
            puts "1 bill added to house ##{house.id} in #{house.address.city.name}: #{bill}"

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
            puts "1 bill added to house ##{house.id} in #{house.address.city.name}: #{bill}\n"

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
          puts "1 bill added to house ##{house.id} in #{house.address.city.name}: #{bill}\n"

puts "created #{Address.where(city: 'Denver').count} addresses in Denver\n\n\n"

# 1 address in Fort Collins
# random everything, no idea how much savings -- NO NEIGHBORHOOD
fzip= Zipcode.create(zipcode: zip_fort)
  fort_add = Address.create(address_line1: "125 Main St", address_line2: "#202",
              city_id: city2.id,
              zipcode_id: fzip.id)

      house = House.create(total_sq_ft: rand(1000..3000), no_residents: rand(1..6), address_id: fort_add.id)
      puts "#{house} added in #{fort_add.city} at #{fort_add.address_line1} in #{fort_add.region}"
      user = bind_new_user(house)
      puts "#{user.first} created with email #{user.email} & password #{user.password}"

            kwhs = rand(100..3000)
            price = rand(40..100)
            bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
          puts "bill added to house ##{house.id} in #{house.address.city.name}: #{bill}"
            kwhs2 = rand(100..3000)
            price2 = rand(40..100)
            sdate = @start_date - 30
            edate = @end_date - 30
            bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id)
          puts "second bill added to house ##{house.id} in #{house.address.city.name}: #{bill2}\n"
            kwhs3 = rand(100..3000)
            price3 = rand(40..100)
            sdate3 = @start_date - 60
            edate3 = @end_date - 60
            bill3 = ElectricBill.create(start_date: sdate3, end_date: edate3, total_kwhs: kwhs3, price: price3, house_id: house.id)
          puts "third bill added to house ##{house.id} in #{house.address.city.name}: #{bill3}\n"
          puts "created #{Address.where(city: 'Fort Collins').count} address in Fort Collins\n\n\n"

# 1 address in Boulder
# random everything, no idea how much savings -- WITH NEIGHBORHOOD
  bzip= Zipcode.create(zipcode: 80305)
        bold_add = Address.create(address_line1: "125 Main St", address_line2: "#202",
                    city_id: city4.id,
                    zipcode_id: bzip.id)

                house = House.create(total_sq_ft: rand(1000..3000), no_residents: rand(1..6), address_id: bold_add.id)
                puts "#{house} added in #{bold_add.city} at #{bold_add.address_line1} in #{bold_add.region.name}"
                user = bind_new_user(house)
                puts "#{user.first} created with email #{user.email} & password #{user.password}"

                      kwhs = rand(100..3000)
                      price = rand(40..100)
                      bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
                    puts "bill added to house ##{house.id} in #{house.address.city.name}: #{bill}"
                      kwhs2 = rand(100..3000)
                      price2 = rand(40..100)
                      sdate = @start_date - 30
                      edate = @end_date - 30
                      bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id)
                    puts "second bill added to house ##{house.id} in #{house.address.city.name}: #{bill2}\n"
                      kwhs3 = rand(100..3000)
                      price3 = rand(40..100)
                      sdate3 = @start_date - 60
                      edate3 = @end_date - 60
                      bill3 = ElectricBill.create(start_date: sdate3, end_date: edate3, total_kwhs: kwhs3, price: price3, house_id: house.id)
                    puts "third bill added to house ##{house.id} in #{house.address.city.name}: #{bill3}\n"
                    puts "created #{Address.where(city: 'Boulder').count} address in Boulder\n\n\n"

# 1 address in Golden
# 2 bills added, 6 residents 1 user;
gzip= Zipcode.create(zipcode: zip_gold)
  gold_add = Address.create(address_line1: "747 Joyce St",
              neighborhood: Neighborhood.create(name: "Green Mountain Valley", city: city3),
              city: city3,
              zipcode_id: gzip.id)

      house = House.create(total_sq_ft: rand(1000..3000), no_residents: 6, address_id: gold_add.id)
      puts "#{house} added in #{gold_add.city} at #{gold_add.address_line1} in #{gold_add.neighborhood.name}"
      user = bind_new_user(house)
      puts "#{user.first} created with email #{user.email} & password #{user.password}"

            kwhs = rand(1000..3000)
            price = rand(1..100)
            bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id)
          puts "bill added to house ##{house.id} in #{house.address.city.name}: #{bill}"
            kwhs2 = rand(1000..3000)
            price2 = rand(1..100)
            sdate = @start_date - 30
            edate = @end_date - 30
            bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id)
          puts "second bill added to house ##{house.id} in #{house.address.city.name}: #{bill2}\n"
          puts "created #{Address.where(city_id: city3.id).count} address in Golden\n\n\n"

GLOBE.update_data
country.update_data
state.update_data
Neighborhood.all.each{|n| n.update_data}
City.all.each{|c| c.update_data}

# # #
# # # COORD = [
# # #          [[46.3625, 15.114444],[46.055556, 14.508333]],
# # #          [[50.82413,  -104.95922], [50.82413, -104.95922]],
# # #          [[-59.3068, 164.92105], [-58.2200, 164.99910]],
# # #          [[-24.82067, -113.06858],[-25.25919, -116.92851]],
# # #          [[-2.66268, -82.91891], [-8.66172, -162.63773]],
# # #          [[29.98702,  -134.26584], [26.98321, -130.39952]]
# # #        ]
