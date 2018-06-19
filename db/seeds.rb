# At this point, integers represent annual average electricity use
#        per household for each region; pending addition of water and gas
require 'csv'

COUNTRIES = {
  :countries => [
  ["Afghanistan", 141, 278701.46],
  ["Albania", 2564, 157842.77],
  ["Algeria", 1216, 51804.1292],
  ["American Samoa", 1845, nil],
  ["Andorra", 6565, nil],
  ["Angola", 401, 228376.694, 11158.62528],
  ["Antigua & Barbuda", 3205, 243091.0744],
  ["Argentina", 2643, 228376.694],
  ["Armenia", 1671, 243091.0744],
  ["Aruba", 7039, nil],
  ["Australia", 9742, 303533.628],
  ["Austria", 8006, 119511.4128],
  ["Azerbaijan", 2025, 373803.38],
  ["Bahamas", 4888 nil],
  ["Bahraim", 18130, 124240.0916],
  ["Bangladesh", 351, 59227.3624],
  ["Barbados", 3087, 64088.1272],
  ["Belarus", 3448, 115099.7404],
  ["Belgium", 7099, 155940.7316],
  ["Belize", 1130, 150102.5304],
  ["Benin", 93, 4829.06416],
  ["Bermuda", 8505, nil],
  ["Bhutan", 2779, 129972.624],
  ["Bolivia", 683, 61816.248],
  ["Bosnia & Herzegovina", 2848, 23735.8542],
  ["Botswana", 1674, 28926.834],
  ["Brazil", 2516, 80678.1288],
  ["Brunei Darussalam", 8625, 78406.2496],
  ["Bulgaria", 4338, 212896.2148],
  ["Burkina Faso", 61, 20919.78068],
  ["Myanmar/Burma", 193, 185343.0752],
  ["Burundi", 36, 11243.16032],
  ["Cambodia", 256, 40286.23],
  ["Cameroon", 250, 15242.7244],
  ["Canada", 14930, 387804.496],
  ["Cape Verde (Cabo Verde)", 542, 12772.7162],
  ["Cayman Islands", 10477, nil],
  ["Central African Republic", 36, 4535.83324],
  ["Chad", 16, 10733.30836],
  ["Chile", 3739, 189833.9992],
  ["China", 2674, 109525.7112],
  ["Colombia", 1270, 81338.5588],
  ["Comoros", 51, 3590.09748],
  ["Congo, Republic of the", 185, 3822.56884],
  ["Cook Islands", 3308, nil],
  ["Costa Rica", 1888, 172689.2364],
  ["Croatia", 3933, 37697.3444],
  ["Cuba", 597, 179161.4504],
  ["Curaçao", 6495, nil],
  ["Cyprus", 3234, 56400.722],
  ["Czech Republic", 5636, 49849.2564],
  ["Democratic Republic of the Congo", 114, 3051.1866],
  ["Denmark", 5720, 31938.3948],
  ["Djibouti", 472, 6577.8828],
  ["Dominican Republic", 1427, 101045.79],
  ["Dominica", 1223, 65461.8216],
  ["Ecuador", 1305, 319119.776],
  ["Egypt", 1510, 247529.164],
  ["El Salvador", 925, 60627.474],
  ["Equatorial Guinea", 120, 8215.7492],
  ["Eritrea", 51, 32149.7324],
  ["Estonia", 6515, 353197.964],
  ["Ethiopia", 65, 21260.56256],
  ["Falkland Islands", 4759, nil],
  ["Fiji", 874, 26549.286],
  ["Finland", 14732, 81708.3996],
  ["France", 6448, 135361.7328],
  ["French Polynesia", 2453 nil],
  ["Gabon", 1207, 26654.9548],
  ["Gambia", 149, 13541.45672],
  ["Gaza Strip", 0.1, nil],
  ["Georgia", 1988, 98271.984],
  ["Germany", 6602, 103634.6756],
  ["Gibraltar", 6819, nil],
  ["Ghana", 341, 12669.68912],
  ["Greece", 4919, 225153.7956],
  ["Greenland", 5196, nil],
  ["Grenada", 1798, 25651.1012],
  ["Guam", 9217, nil],
  ["Guatemala", 586, 65699.5764],
  ["Guinea", 74, 49162.4092],
  ["Guinea-Bissau", 17, 33761.1816],
  ["Guyana", 1087, 570875.692],
  ["Haiti", 38, 35399.048],
  ["Honduras", 595, 48607.648],
  ["Hong Kong", 5859, nil],
  ["Hungary", 2182, 147196.6384],
  ["Iceland", 50613, 141516.9404],
  ["India", 1122, 170153.1852],
  ["Indonesia", 754, 141939.6156],
  ["Iran", 2632, 340253.536],
  ["Iraq", 1101, 667034.3],
  ["Ireland", 5047, 60072.7128],
  ["Israel", 7319, 74470.0868],
  ["Italy", 4692, 208326.0392],
  ["Ivory Coast (Cote d'Ivoire)", 244, 20592.2074],
  ["Jamaica", 942, 59174.528],
  ["Japan", 7371, 187139.4448],
  ["Jordan", 1954, 41844.8448],
  ["Kazakhstan", 4956, 584876.808],
  ["Kenya", 162, 19136.61968],
  ["Kiribati", 260, nil],
  ["Kosovo", 1533, nil],
  ["Kuwait", 19062, 98905.9968],
  ["Kyrgyz Republic (Kyrgyzstan)", 1920, 525438.108],
  ["Laos", 555, 141543.3576],
  ["Latvia", 3459, 46679.1924],
  ["Lebanon", 2565, 83161.3456],
  ["Lesotho", 409, 6818.27932],
  ["Liberia", 69, 15425.00308],
  ["Libya", 1421, 205208.8096],
  ["Liechtenstein", 35848, nil],
  ["Lithuania", 3468, 187192.2792],
  ["Luxembourg", 10647, 35504.7168],
  ["Macau", 7532, nil],
  ["Republic of Macedonia", 3314, 133116.2708],
  ["Madagascar", 53, 239524.7524],
  ["Malawi", 102, 20402.00356],
  ["Malaysia", 4232, 135071.1436],
  ["Maldives", 763, 5109.08648],
  ["Mali", 80, 157050.254],
  ["Malta", 4817, 36138.7296],
  ["Marshall Islands", 8177, nil],
  ["Mauritania", 217, 153616.018],
  ["Mauritius", 1928, 150683.7088],
  ["Mexico", 1932, 194192.8372],
  ["Moldova, Republic of", 1226, 127727.162],
  ["Mongolia", 1847, 53917.5052],
  ["Montenegro", 4343, nil],
  ["Montserrat", 4061, nil],
  ["Morocco", 861, 112854.2784],
  ["Mozambique", 462, 10207.60608],
  ["Namibia", 1518, 41765.5932],
  ["Nauru", 2424, nil],
  ["Nepal", 134, 103951.682],
  ["Netherlands", 6346, 169572.0068],
  ["New Zealand", 8939, 317006.4],
  ["Nicaragua", 739, 64827.8088],
  ["Niger", 64, 52940.0688],
  ["Nigeria", 128, 20782.41124],
  ["Korea, Democratic Republic of (North Korea)", 1347, 78723.256],
  ["Norway", 24006, 164499.9044],
  ["Oman", 7450, 128017.7512],
  ["Pakistan", 405, 273946.364],
  ["Panama", 2105, 38965.37],
  ["Papua New Guinea", 441, 12632.70504],
  ["Paraguay", 1413, 23236.56912],
  ["Peru", 1268, 190890.6872],
  ["Philippines", 885, 238468.0644],
  ["Poland", 3686, 82923.5908],
  ["Portugal", 4245, 215960.61],
  ["Puerto Rico", 5310, 66571.344],
  ["Qatar", 15055, 103079.9144],
  ["Romania", 2222, 85036.9668],
  ["Russian Federation", 7481, 120330.346],
  ["Rwanda", 38, 4641.50204],
  ["Saint Kitts and Nevis", 3821, nil],
  ["Saint Lucia", 1824, 25946.97384],
  ["Saint Vincent's & Grenadines", 977, 24459.68548],
  ["Samoa", 502, nil],
  ["Sao Tome and Principe", 329, 13903.37236],
  ["Saudi Arabia", 9658, 253367.3652],
  ["Senegal", 209, 56242.2188],
  ["Serbia", 3766, 110635.2336],
  ["Seychelles", 3219, 43614.7972],
  ["Sierra Leone", 33, 28689.0792],
  ["Singapore", 8160, 21654.17884],
  ["Slovak Republic (Slovakia)", 5207, 33681.93],
  ["Slovenia", 6572, 123500.41],
  ["Solomon Islands", 124, nil],
  ["Somalia", 27, 99751.3472],
  ["South Africa", 3904, 71484.9432],
  ["Korea, Republic of (South Korea)", 9720, 143313.31],
  ["South Sudan", 55, nil],
  ["Spain", 4818, 192766.3084],
  ["Sri Lanka", 494, 172055.2236],
  ["Sudan", 269, 269455.44],
  ["Suriname", 3243, 367991.596],
  ["Swaziland", 1033, 250012.3808],
  ["Sweden", 12853, 75447.5232],
  ["Switzerland", 7091, 94837.748],
  ["Syria", 989, 215934.1928],
  ["Tajikistan", 1440, 500605.94],
  ["Tanzania", 95, 38093.6024],
  ["Thailand", 2404, 226025.5632],
  ["Taiwan", 10632, nil],
  ["Timor Leste", 99, 291117.544],
  ["Togo", 141, 8038.75396],
  ["Tonga", 436, nil],
  ["Trinidad & Tobago", 7456, 46890.53],
  ["Tunisia", 1341, 78247.7464],
  ["Turkey", 2578, 145109.6796],
  ["Turkmenistan", 2456, 1419924.5],
  ["Turks & Caicos Islands", 3888, nil],
  ["Uganda", 70, 3344.41752],
  ["Ukraine", 3234, 211654.6064],
  ["United Arab Emirates", 16195, 242007.9692],
  ["United Kingdom (Great Britain)", 4796, 56136.55],
  ["United States of America", 12071, 409466.6],
  ["Uruguay", 2984, 290589.2],
  ["Uzbekistan", 1628, 619483.34],
  ["Vanuatu", 201, nil],
  ["Venezuela", 2532, 94520.7416],
  ["Vietnam", 1312, 251650.2472],
  ["Virgin Islands (UK)", 2921, nil],
  ["Virgin Islands (US)", 5828, nil],
  ["West Bank", 1927, 27500.3052],
  ["Yemen", 189, 42293.9372],
  ["Zambia", 709, 41897.6792],
  ["Zimbabwe", 549, 135678.7392],
  ]
}

GLOBE = Global.create

COUNTRIES[:countries].each do |c|
  edaily_avg = c[1].fdiv(30)
  wdaily_avg = c[2].fdiv(365)
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

CO_COUNTIES = [
  "Adams County",
  "Alamosa County",
  "Arapahoe County",
  "Archuleta County",
  "Baca County",
  "Bent County",
  "Boulder County",
  "Broomfield County",
  "Caffee County",
  "Cheyenne County",
  "Clear Creek County",
  "Conejos County",
  "Costilla County",
  "Crowley County",
  "Custer County",
  "Delta County",
  "Denver County",
  "Dolores County",
  "Douglas County",
  "Eagle County",
  "El Paso County",
  "Elbert County",
  "Fremont County",
  "Garfield County",
  "Gilpin County",
  "Grand County",
  "Gunnison County",
  "Hinsdale County",
  "Huerfano County",
  "Jackson County",
  "Jefferson County",
  "Kiowa County",
  "Kit Carson County",
  "La Plata County",
  "Lake County",
  "Larimer County",
  "Las Animas County",
  "Lincoln County",
  "Logan County",
  "Mesa County",
  "Mineral County",
  "Moffat County",
  "Montezuma County",
  "Montrose County",
  "Morgan County",
  "Otero County",
  "Ouray County",
  "Park County",
  "Phillips County",
  "Pitkin County",
  "Prowers County",
  "Pueblo County",
  "Rio Blanco County",
  "Rio Grande County",
  "Routt County",
  "Saguache County",
  "San Juan County",
  "San Miguel County",
  "Sedgwick County",
  "Summit County",
  "Teller County",
  "Washington County",
  "Weld County",
  "Yuma County"
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
                  generation: 0,
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
CO_COUNTIES.each do |countie|
  County.create(name: countie, region_id: state.id)
end
county = County.find_by(name: "Denver County")
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
                  neighborhood_id: dn1.id, city_id: city1.id, county_id: county.id,
                  zipcode_id: z.id)

    #HOUSE NUMBER 1; 2 resident users; savings in 3/4 bills;
          house = House.create(total_sq_ft: rand(1000..3000), no_residents: 0, address_id: tadd.id)
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
                neighborhood: dn1, city: city1, county_id: county.id,
                zipcode_id: z.id)

    # HOUSE NUMBER 2; 5 residents, 3 users; Colorado: 723; savings in 5/5 bills
        house2 = House.create!(total_sq_ft: rand(1000..3000), no_residents:2, address_id: sadd.id)
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
                          county_id: county.id,
                          zipcode_id: gzip.id)

                  house = House.create(total_sq_ft: rand(1000..3000), no_residents: 5, address_id: gold_add.id)
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
                  neighborhood: dn2, city: city1, county_id: county.id,
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
                  zipcode_id: z2.id, county_id: county.id)

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
                  neighborhood: dn3, city: city1, county_id: county.id,
                  zipcode_id: z2.id)
          house = House.create(total_sq_ft: 3500, no_residents: 2, address_id: gadd.id)
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
                neighborhood: dn3, city: city1, county_id: county.id,
                zipcode_id: z3.id)
            dan = User.create(first: "Daniel", last: "Vog",
                              email: 'dvog@gmail.com',
                              generation: 0,
                              password: 'password')

        house = House.create!(total_sq_ft: rand(1000..3000), no_residents: 2, address_id: dadd.id)
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
                    city_id: city1.id, county_id: county.id,
                    neighborhood: Neighborhood.find(rand(10..18)),
                    zipcode_id: bzip.id)
        # this address is a trial to test for address validations of address_line1 + address_line2
        rand_two = Address.create(address_line1: "1981 E 18th St", address_line2: "#204",
                    city_id: city1.id, county_id: county.id,
                    neighborhood: rand_add.neighborhood, zipcode_id: bzip.id)

                house2 = House.create(total_sq_ft: 400, no_residents: 1, address_id: rand_two.id)
                bind_new_user(house)
                puts "#{house2} added at #{rand_add.address_line1}, #{rand_add.address_line2} in #{rand_add.neighborhood.name} with no bills"

                house = House.create(total_sq_ft: 600, no_residents: rand(0..4), address_id: rand_add.id)
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
Country.all.each do |c|
  c.set_default_ranks
  # set carbon_avg_user and dont update it on countries 
end
country.update_data

Region.all.each{|r| r.set_default_ranks}

state.update_data

User.all.each{|u|
   hId = u.household.id
   UserElectricityQuestion.create(user_id: u.id, house_id: hId)
   UserWaterQuestion.create(user_id: u.id, house_id: hId)
   UserGasQuestion.create(user_id: u.id, house_id: hId)
   u.email_activate
   u.set_default_ranks
 }

County.all.each do |c|
  c.set_default_ranks
  c.update_data
end

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
