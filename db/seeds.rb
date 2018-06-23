# At this point, integers represent annual average electricity use
#        per household for each region; pending addition of water and gas
require 'csv'

COUNTRIES = {
  :countries => [
  ["Afghanistan", 141, 278701.46, nil, 0.0293],
  ["Albania", 2564, 157842.77, nil, 1.5215],
  ["Algeria", 1216, 51804.1292, nil, 3.3197],
  ["American Samoa", 1845, nil, nil, 10.349],
  # ["Andorra", 6565, nil, nil, nil],
  ["Angola", 401, 11158.62528, nil, 1.8646],
  ["Antigua & Barbuda", 3205, 243091.0744, nil, 8.0374],
  ["Argentina", 2643, 228376.694, nil, 4.0555],
  ["Armenia", 1671, 243091.0744, nil, 3.8251],
  ["Aruba", 7039, nil, nil, 10.8368],
  ["Australia", 9742, 303533.628, nil, 19.6439],
  ["Austria", 8006, 119511.4128, nil, 8.4334],
  ["Azerbaijan", 2025, 373803.38, nil, 4.2389],
  ["Bahamas", 4888, nil, nil, 17.0234],
  ["Bahraim", 18130, 124240.0916, nil, 42.5527],
  ["Bangladesh", 351, 59227.3624, nil, 0.3587],
  ["Barbados", 3087, 64088.1272, nil, 5.0217],
  ["Belarus", 3448, 115099.7404, nil, 6.2786],
  ["Belgium", 7099, 155940.7316, nil, 13.1896],
  ["Belize", 1130, 150102.5304, nil, 3.1922],
  ["Benin", 93, 4829.06416, nil, 0.3986],
  ["Bermuda", 8505, nil, nil, 11.5207],
  ["Bhutan", 2779, 129972.624, nil, 0.4837],
  ["Bolivia", 683, 61816.248, nil, 1.3936],
  ["Bosnia & Herzegovina", 2848, 23735.8542, nil, 3.9787],
  ["Botswana", 1674, 28926.834, nil, 2.2771],
  ["Brazil", 2516, 80678.1288, nil, 2.1393],
  ["Brunei Darussalam", 8625, 78406.2496, nil, 19.5201],
  ["Bulgaria", 4338, 212896.2148, nil, 6.1754],
  ["Burkina Faso", 61, 20919.78068, nil, 0.0898],
  ["Burundi", 36, 11243.16032, nil, 0.0388],
  ["Cambodia", 256, 40286.23, nil, 0.2764],
  ["Cameroon", 250, 15242.7244, nil, 0.3966],
  ["Canada", 14930, 387804.496, nil, 16.1544],
  ["Cape Verde", 542, 12772.7162, nil, 0.6769],
  ["Cayman Islands", 10477, nil, nil, 8.7375],
  ["Central African Republic", 36, 4535.83324, nil, 0.0623],
  ["Chad", 16, 10733.30836, nil, 0.0282],
  ["Chile", 3739, 189833.9992, nil, 3.7679],
  ["China", 2674, 109525.7112, nil, 5.8227],
  ["Colombia", 1270, 81338.5588, nil, 1.607],
  ["Comoros", 51, 3590.09748, nil, 0.1988],
  ["Congo, Republic of the", 185, 3822.56884, nil, 1.5741],
  ["Cook Islands", 3308, nil, nil, 12.7204],
  ["Costa Rica", 1888, 172689.2364, nil, 1.5316],
  ["Croatia", 3933, 37697.3444, nil, 4.739],
  ["Cuba", 597, 179161.4504, nil, 2.6624],
  ["Curaçao", 6495, nil, nil, nil],
  ["Cyprus", 3234, 56400.722, nil, 8.7183],
  ["Czech Republic", 5636, 49849.2564, nil, 9.3346],
  ["Democratic Republic of the Congo", 114, 3051.1866, nil, 0.0385],
  ["Denmark", 5720, 31938.3948, nil, 9.01],
  ["Djibouti", 472, 6577.8828, nil, 2.4342],
  ["Dominican Republic", 1427, 101045.79, nil, 2.0441],
  ["Dominica", 1223, 65461.8216, nil, 1.9434],
  ["Ecuador", 1305, 319119.776, nil, 1.8905],
  ["Egypt", 1510, 247529.164, nil, 2.4032],
  ["El Salvador", 925, 60627.474, nil, 0.9836],
  ["Equatorial Guinea", 120, 8215.7492, nil, 7.2658],
  ["Eritrea", 51, 32149.7324, nil, 0.1373],
  ["Estonia", 6515, 353197.964, nil, 13.5117],
  ["Ethiopia", 65, 21260.56256, nil, 0.0808],
  ["Falkland Islands", 4759, nil, nil, 14.578],
  ["Fiji", 874, 26549.286, nil, 2.563],
  ["Finland", 14732, 81708.3996, nil, 9.9329],
  ["France", 6448, 135361.7328, nil, 6.2978],
  ["French Polynesia", 2453, nil, nil, 3.7224],
  ["Gabon", 1207, 26654.9548, nil, 3.031],
  ["Gambia", 149, 13541.45672, nil, 0.2455],
  # ["Gaza Strip", 0.1, nil, nil, nil],
  ["Georgia", 1988, 98271.984, nil, 1.1417],
  ["Germany", 6602, 103634.6756, nil, 9.2987],
  # ["Gibraltar", 6819, nil, nil, 151.9837],
  ["Ghana", 341, 12669.68912, nil, 0.3391],
  ["Greece", 4919, 225153.7956, nil, 9.348],
  # ["Greenland", 5196, nil, nil, 10.6101],
  ["Grenada", 1798, 25651.1012, nil, 2.8036],
  ["Guam", 9217, nil, nil, 9.596],
  ["Guatemala", 586, 65699.5764, nil, 0.8587],
  ["Guinea", 74, 49162.4092, nil, 0.1323],
  ["Guinea-Bissau", 17, 33761.1816, nil, 0.301],
  ["Guyana", 1087, 570875.692, nil, 2.0192],
  ["Haiti", 38, 35399.048, nil, 0.2112],
  ["Honduras", 595, 48607.648, nil, 1.0232],
  ["Hong Kong", 5859, nil, nil, 12.3687],
  ["Hungary", 2182, 147196.6384, nil, 4.9998],
  ["Iceland", 50613, 141516.9404, nil, 11.1187],
  ["India", 1122, 170153.1852, nil, 1.3753],
  ["Indonesia", 754, 141939.6156, nil, 1.727],
  ["Iran", 2632, 340253.53, nil, 6.9583],
  ["Iraq", 1101, 667034.3, nil, 3.7456],
  ["Ireland", 5047, 60072.7128, nil, 8.7936],
  ["Israel", 7319, 74470.0868, nil, 9.6857],
  ["Italy", 4692, 208326.0392, nil, 7.0132],
  ["Ivory Coast", 244, 20592.2074, nil, 0.3164],
  ["Jamaica", 942, 59174.528, nil, 4.2598],
  ["Japan", 7371, 187139.4448, nil, 8.64],
  ["Jordan", 1954, 41844.8448, nil, 3.1537],
  ["Kazakhstan", 4956, 584876.808, nil, 11.9565],
  ["Kenya", 162, 19136.61968, nil, 0.2928],
  ["Kiribati", 260, nil, nil, 0.445],
  ["Kosovo", 1533, nil, nil, nil],
  ["Kuwait", 19062, 98905.9968, nil, 31.077],
  ["Kyrgyzstan", 1920, 525438.108, nil, 1.042],
  ["Laos", 555, 141543.3576, nil, 0.1984],
  ["Latvia", 3459, 46679.1924, nil, 3.899],
  ["Lebanon", 2565, 83161.3456, nil, 3.7036],
  ["Lesotho", 409, 6818.27932, nil, 0.1325],
  ["Liberia", 69, 15425.00308, nil, 0.197],
  ["Libya", 1421, 205208.8096, nil, 8.7025],
  ["Liechtenstein", 35848, nil, nil, nil],
  ["Lithuania", 3468, 187192.2792, nil, 4.4752],
  ["Luxembourg", 10647, 35504.7168, nil, 21.5132],
  ["Macau", 7532, nil, nil, 4.3302],
  ["Republic of Macedonia", 3314, 133116.2708, nil, 3.5704],
  ["Madagascar", 53, 239524.7524, nil, 0.1541],
  ["Malawi", 102, 20402.00356, nil, 0.0853],
  ["Malaysia", 4232, 135071.1436, nil, 5.378],
  ["Maldives", 763, 5109.08648, nil, 2.3186],
  ["Mali", 80, 157050.254, nil, 0.055],
  ["Malta", 4817, 36138.7296, nil, 7.6421],
  ["Marshall Islands", 8177, nil, nil, nil],
  ["Mauritania", 217, 153616.018, nil, 0.9275],
  ["Mauritius", 1928, 150683.7088, nil, 3.5393],
  ["Mexico", 1932, 194192.8372, nil, 3.9889],
  ["Moldova, Republic of", 1226, 127727.162, nil, 1.6296],
  ["Mongolia", 1847, 53917.5052, nil, 2.4291],
  ["Montenegro", 4343, nil, nil, 2.8878],
  ["Montserrat", 4061, nil, nil, 28.8542],
  ["Morocco", 861, 112854.2784, nil, 1.1642],
  ["Mozambique", 462, 10207.60608, nil, 0.1077],
  ["Myanmar", 193, 185343.0752, nil, 0.2376],
  ["Namibia", 1518, 41765.5932, nil, 1.935],
  ["Nauru", 2424, nil, nil, 22.015],
  ["Nepal", 134, 103951.682, nil, 0.12],
  ["Netherlands", 6346, 169572.0068, nil, 14.8903],
  ["New Zealand", 8939, 317006.4, nil, 9.2768],
  ["Nicaragua", 739, 64827.8088, nil, 0.7419],
  ["Niger", 64, 52940.0688, nil, 0.0875],
  ["Nigeria", 128, 20782.41124, nil, 0.5239],
  ["North Korea", 1347, 78723.256, nil, 3.5098],
  ["Norway", 24006, 164499.9044, nil, 8.4927],
  ["Oman", 7450, 128017.7512, nil, 16.8044],
  ["Pakistan", 405, 273946.364, nil, 0.7734],
  ["Palestine", 1927, 27500.3052, nil, 0.7827],
  ["Panama", 2105, 38965.37, nil, 4.535],
  ["Papua New Guinea", 441, 12632.70504, nil, 0.8173],
  ["Paraguay", 1413, 23236.56912, nil, 0.6309],
  ["Peru", 1268, 190890.6872, nil, 1.2057],
  ["Philippines", 885, 238468.0644, nil, 0.7353],
  ["Poland", 3686, 82923.5908, nil, 7.4263],
  ["Portugal", 4245, 215960.61, nil, 5.281],
  # ["Puerto Rico", 5310, 66571.344, nil, 8.384],
  ["Qatar", 15055, 103079.9144, nil, 76.3764],
  ["Romania", 2222, 85036.9668, nil, 3.635],
  ["Russia", 7481, 120330.346, nil, 11.1157],
  ["Rwanda", 38, 4641.50204, nil, 0.0674],
  ["Saint Kitts and Nevis", 3821, nil, nil, 6.1336],
  ["Saint Lucia", 1824, 25946.97384, nil, 2.6882],
  ["Saint Vincent's & Grenadines", 977, 24459.68548, nil, 2.6882],
  ["Samoa", 502, nil, nil, 0.7722],
  ["Sao Tome and Principe", 329, 13903.37236, nil, 0.873],
  ["Saudi Arabia", 9658, 253367.3652, nil, 17.3023],
  ["Senegal", 209, 56242.2188, nil, 0.5157],
  ["Serbia", 3766, 110635.2336, nil, 5.4499],
  ["Seychelles", 3219, 43614.7972, nil, 12.4568],
  ["Sierra Leone", 33, 28689.0792, nil, 0.2601],
  ["Singapore", 8160, 21654.17884, nil, 33.5696],
  ["Slovakia", 5207, 33681.93, nil, 6.5442],
  ["Slovenia", 6572, 123500.41, nil, 8.6661],
  ["Solomon Islands", 124, nil, nil, 0.5255],
  ["Somalia", 27, 99751.3472, nil, 0.0913],
  ["South Africa", 3904, 71484.9432, nil, 9.1987],
  ["South Korea", 9720, 143313.31, nil, 10.8874],
  # ["South Sudan", 55, nil, nil, nil],
  ["Spain", 4818, 192766.3084, nil, 7.1251],
  ["Sri Lanka", 494, 172055.2236, nil, 0.5934],
  ["Sudan", 269, 269455.44, nil, 0.3024],
  ["Suriname", 3243, 367991.596, nil, 4.2192],
  ["Swaziland", 1033, 250012.3808, nil, 1.0348],
  ["Sweden", 12853, 75447.5232, nil, 5.5805],
  ["Switzerland", 7091, 94837.748, nil, 5.9969],
  ["Syria", 989, 215934.1928, nil, 2.6714],
  ["Tajikistan", 1440, 500605.94, nil, 0.8406],
  ["Tanzania", 95, 38093.6024, nil, 0.1633],
  ["Thailand", 2404, 226025.5632, nil, 3.8245],
  ["Taiwan", 10632, nil, nil, 12.1502],
  ["Timor Leste", 99, 291117.544, nil, 0.3381],
  ["Togo", 141, 8038.75396, nil, 0.4524],
  ["Tonga", 436, nil, nil, 1.2824],
  ["Trinidad & Tobago", 7456, 46890.53, nil, 38.6048],
  ["Tunisia", 1341, 78247.7464, nil, 2.1858],
  ["Turkey", 2578, 145109.6796, nil, 3.2948],
  ["Turkmenistan", 2456, 1419924.5, nil, 11.5969],
  ["Turks & Caicos Islands", 3888, nil, nil, 3.3896],
  ["Uganda", 70, 3344.41752, nil, 0.0589],
  ["Ukraine", 3234, 211654.6064, nil, 5.5245],
  ["United Arab Emirates", 16195, 242007.9692, nil, 40.3006],
  ["United Kingdom", 4796, 56136.55, nil, 8.3514],
  ["United States of America", 12071, 409466.6, nil, 17.6691],
  ["Uruguay", 2984, 290589.2, nil, 2.0567],
  ["Uzbekistan", 1628, 619483.34, nil, 4.1723],
  ["Vanuatu", 201, nil, nil, 0.6705],
  ["Venezuela", 2532, 94520.7416, nil, 5.9294],
  ["Vietnam", 1312, 251650.2472, nil, 1.1102],
  ["Yemen", 189, 42293.9372, nil, 1.1279],
  ["Zambia", 709, 41897.6792, nil, 0.2047],
  ["Zimbabwe", 549, 135678.7392, nil, 0.9321],
  ]
}

GLOBE = Global.create

COUNTRIES[:countries].each do |c|
  edaily_avg = c[1].fdiv(30)
  wdaily_avg = c[2].fdiv(365) if c[2]
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

Country.all.each{|c| c.set_default_ranks}

COUNTRIES[:countries].each do |c|
  name = c[0]
  country = Country.find_by(name: name)
  arg = c[4] || 0
  country.update_carbon_consumption((arg * 2204.6).fdiv(365))
end

puts "You have #{Country.count} countries in the database prepped and ready"

# All states have electric, water, and gas averages
STATES = [
  ["Alabama", 1211, 82, 10.92, 25.05],
  ["Alaska", 632, 94, 23.33, 47.17],
  ["Arizona", 1049, 142, 5.86, 13.79],
  ["Arkansas", 1133, 100, 9.83, 23.13],
  ["California", 557, 126, 5.47, 9.26],
  ["Colorado", 723, 123, 7.56, 16.95],
  ["Connecticut", 752, 77, 5.83, 9.77],
  ["Delaware", 944, 63, 8.17, 14.24],
  ["Florida", 1078, 98, 5.83, 11.41],
  ["Georgia", 1088, 95, 7.78, 13.76],
  ["Hawaii", 515, 169, 5.50, 12.82],
  ["Idaho", 1055, 187, 8.81, 10.18],
  ["Illinois", 755, 92, 8.53, 18.12],
  ["Indiana", 1005, 78, 11.94, 30.81],
  ["Iowa", 908, 67, 13.31, 26.78],
  ["Kansas", 926, 83, 10.53, 23.97],
  ["Kentucky", 1154, 69, 10.83, 31.19],
  ["Louisiana", 1273, 119, 25.33, 44.5],
  ["Maine", 551, 56, 8.47, 12.52],
  ["Maryland", 1031, 111, 6.57, 10.38],
  ["Massachusetts", 632, 84, 5.92, 9.49],
  ["Michigan", 665, 82, 7.75, 16.31],
  ["Minnesota", 817, 70, 8.97, 17.24],
  ["Mississippi", 1220, 118, 10.53, 21.28],
  ["Missouri", 1086, 90, 8.36, 21.66],
  ["Montana", 860, 114, 10.53, 31.51],
  ["Nebraska", 1034, 137, 12.50, 27.51],
  ["Nevada", 924, 192, 6.25, 13.02],
  ["New Hampshire", 629, 77, 6.36, 11.25],
  ["New Jersey", 687, 71, 7.11, 12.78],
  ["New Mexico", 655, 109, 9.31, 24.07],
  ["New York", 602, 99, 5.25, 8.61],
  ["North Carolina", 1098, 72, 6.97, 12.64],
  ["North Dakota", 1205, 93, 22.31, 74.81],
  ["Ohio", 892, 71, 8.94, 19.75],
  ["Oklahoma", 1142, 87, 11.58, 26.92],
  ["Oregon", 976, 123, 6.61, 9.56],
  ["Pennsylvania", 857, 59, 8.42, 18.94],
  ["Rhode Island", 602, 81, 5.33, 10.08],
  ["South Carolina", 1124, 102, 9.36, 15.39],
  ["South Dakota", 1055, 96, 12.42, 17.91],
  ["Tennessee", 1245, 82, 9.14, 15.69],
  ["Texas", 1174, 139, 13.06, 26.29],
  ["Utah", 798, 188, 7.33, 21.9],
  ["Vermont", 569, 66, 5.86, 9.38],
  ["Virginia", 1156, 77, 7.86, 12.42],
  ["Washington", 1041, 105, 7.72, 10.4],
  ["West Virginia", 1118, 103, 11.69, 52.47],
  ["Wisconsin", 703, 59, 8.56, 17.47],
  ["Wyoming", 894, 154, 24.81, 111.55]
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
                avg_daily_electricity_consumed_per_user: state_avg,
                avg_daily_water_consumed_per_user: r[2],
                avg_daily_gas_consumed_per_user: r[3],
                country_id: Country.find_by(name: "United States of America").id,
               )
end

Region.all.each{|r| r.set_default_ranks}

STATES.each do |r|
  state = Region.find_by(name: r[0])
  carbon_avg = (r[4] * 2204.6).fdiv(365)
  state.update_carbon_consumption(carbon_avg)
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
                bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2)
              puts "bill added to house ##{house.id} in #{house.address.city.name}: #{bill}"
                kwhs2 = 1200
                price2 = rand(1..100)
                sdate = @start_date - 30
                edate = @end_date - 30
                bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id, no_residents: 2)
              puts "second bill added to house ##{house.id} in #{house.address.city.name}: #{bill2}"
                kwhs3 = 1000
                price3 = rand(1..100)
                sdate3 = @start_date - 60
                edate3 = @end_date - 60
                bill3 = ElectricBill.create(start_date: sdate3, end_date: edate3, total_kwhs: kwhs3, price: price3, house_id: house.id, no_residents: 2)
              puts "third bill added to house ##{house.id} in #{house.address.city.name}: #{bill3}"
                kwhs4 = 2000
                price4 = rand(1..100)
                sdate4 = @start_date - 90
                edate4 = @end_date - 90
                bill4 = ElectricBill.create(start_date: sdate4, end_date: edate4, total_kwhs: kwhs4, price: price4, house_id: house.id, no_residents: 2)
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
              ebill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house2.id, no_residents: 5)
              wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 12000, price: price, house_id: house2.id, no_residents: 5)
            puts "2 bills added to house ##{house2.id} in #{house2.address.city}: #{ebill}, #{wbill}"
              kwhs2 = rand(1000..3000)
              price2 = rand(1..100)
              sdate = @start_date - 30
              edate = @end_date - 30
              bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house2.id, no_residents: 5)
              wbill2 = WaterBill.create(start_date: sdate, end_date: edate, total_gallons: 15000, price: price, house_id: house2.id, no_residents: 5)

            puts "second bill added to house ##{house2.id} in #{house2.address.city}: #{bill2}, #{wbill2}"
              kwhs2 = rand(1000..3000)
              price2 = rand(100..200)
              sdate = @start_date - 60
              edate = @end_date - 60
              bill3 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house2.id, no_residents: 5)
              wbill3 = WaterBill.create(start_date: sdate, end_date: edate, total_gallons: 14000, price: price2, house_id: house2.id, no_residents: 5)

            puts "third bill added to house ##{house2.id} in #{house2.address.city}: #{bill3}, #{wbill3}"
              kwhs2 = rand(1000..3000)
              price2 = rand(100..200)
              sdate = @start_date - 90
              edate = @end_date - 90
              bill4 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house2.id, no_residents: 5)
              wbill4 = WaterBill.create(start_date: sdate, end_date: edate, total_gallons: 13670, price: price2, house_id: house2.id, no_residents: 5)

            puts "fourth bill added to house ##{house2.id} in #{house2.address.city}: #{bill4}, #{wbill4}"
              kwhs2 = rand(1000..3000)
              price2 = rand(100..200)
              sdate = @start_date - 120
              edate = @end_date - 120
              bill5 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house2.id, no_residents: 5)
              # no save here suspected
              wbill5 = WaterBill.create(start_date: sdate, end_date: edate, total_gallons: 16670, price: price2, house_id: house2.id, no_residents: 5)

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
                        bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 6)
                        wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 17830, price: price, house_id: house.id, no_residents: 6)

                      puts "bill added to house ##{house.id} in #{house.address.city.name}: #{bill}"
                        kwhs2 = rand(1000..3000)
                        price2 = rand(1..100)
                        sdate = @start_date - 30
                        edate = @end_date - 30
                        bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id, no_residents: 6)
                        wbill2 = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 15000, price: price, house_id: house.id, no_residents: 6)

                      puts "second set of bills added to house ##{house.id} in #{house.address.city.name}: #{bill2}, #{wbill2}\n"
                      wbill3 = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 20000, price: price, house_id: house.id, no_residents: 6)
                      puts "third water bill added to house ##{house.id} in #{house.address.city.name}: #{wbill3}\n"

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
              bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2)
              wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 17270, price: price, house_id: house.id, no_residents: 2)
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
                bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2)
                wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: gals, price: price, house_id: house.id, no_residents: 2)

              puts "bill added to house ##{house.id} in #{house.address.city.name}: #{bill}, #{wbill}"
                kwhs2 = rand(100..3000)
                gals2 = gals.fdiv(2)
                price2 = rand(40..100)
                sdate = @start_date - 30
                edate = @end_date - 30
                bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id, no_residents: 2)
                wbill2 = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: gals2, price: price, house_id: house.id, no_residents: 2)

              puts "second bill added to house ##{house.id} in #{house.address.city.name}: #{bill2}, #{wbill2}\n"
                kwhs3 = rand(100..3000)
                price3 = rand(40..100)
                sdate3 = @start_date - 60
                edate3 = @end_date - 60
                gals3 = rand(1000..15000)
                bill3 = ElectricBill.create(start_date: sdate3, end_date: edate3, total_kwhs: kwhs3, price: price3, house_id: house.id, no_residents: 2)
                wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: gals3, price: price, house_id: house.id, no_residents: 2)

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
              bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 4)
              wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 17270, price: price, house_id: house.id, no_residents: 4)
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
        bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2)
        wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: 10000, price: 34.66, house_id: house.id, no_residents: 2)
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
                bind_new_user(house2)
                puts "#{house2} added at #{rand_add.address_line1}, #{rand_add.address_line2} in #{rand_add.neighborhood.name} with no bills"

                house = House.create(total_sq_ft: 600, no_residents: rand(0..4), address_id: rand_add.id)
                puts "#{house} added in #{rand_add.city} at same address, different apartment: #{rand_add.address_line1}, #{rand_add.address_line2}"
                user = bind_new_user(house2)
                puts "#{user.first} created with email #{user.email} & password #{user.password}"

                      kwhs = rand(100..3000)
                      price = rand(40..100)
                      gals = rand(1000..40000)
                      bill = ElectricBill.create(start_date: @start_date, end_date: @end_date, total_kwhs: kwhs, price: price, house_id: house.id, no_residents: 2)
                      wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: gals, price: price, house_id: house.id, no_residents: 1)

                    puts "bill added to house ##{house.id} in #{house.address.city.name}: #{bill}"
                      kwhs2 = rand(100..3000)
                      price2 = rand(40..100)
                      sdate = @start_date - 30
                      edate = @end_date - 30
                      gals = rand(1000..40000)

                      bill2 = ElectricBill.create(start_date: sdate, end_date: edate, total_kwhs: kwhs2, price: price2, house_id: house.id, no_residents: 1)
                      wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: gals, price: price, house_id: house.id, no_residents: 1)

                    puts "second bill added to house ##{house.id} in #{house.address.city.name}: #{bill2}\n"
                      kwhs3 = rand(100..3000)
                      price3 = rand(40..100)
                      sdate3 = @start_date - 60
                      edate3 = @end_date - 60
                      gals = rand(1000..40000)

                      bill3 = ElectricBill.create(start_date: sdate3, end_date: edate3, total_kwhs: kwhs3, price: price3, house_id: house.id, no_residents: 2)
                      wbill = WaterBill.create(start_date: @start_date, end_date: @end_date, total_gallons: gals, price: price, house_id: house.id, no_residents: 2)

                    puts "third bill added to house ##{house.id} in #{house.address.city.name}: #{bill3}\n"
                    puts "created address in #{house.address.neighborhood.name}\n\n\n"

GLOBE.update_data

country.update_data

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
