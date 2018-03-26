require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)

ZIPS = [80204, 80205, 80207, 80209, 80216, 80218, 80202, 80211, 80220]
ZIPS.each{ |zc| Zipcode.create!(zipcode: zc) }

COUNTRIES = [
["Afghanistan", 141],
["Albania", 2564],
["Algeria", 1216],
["American Samoa", 1845]
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
["Guam", 9217]
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
["Macau", 7532]
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
["United Kingdom (Great Britain)", 4796]
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
["Zimbabwe", 549]
]

COUNTRIES.each do
  |c| Country.create(name: c[0], tepc: c[1], mepc: c[1]/12, tcspc: 0, mcspc: 0)
end
#
# 8.times do |n|
#   user = User.create!(
#                 first: Faker::HarryPotter.character.split(/\W/)[0],
#                 last: Faker::LordOfTheRings.character.split(/\W/)[0],
#                 email: Faker::Internet.email,
#                 password: 'banana',
#                 school: Faker::HarryPotter.house,
#                 workplace: Faker::Company.name,
#                 location: Array.new,
#                 url: Faker::Avatar.image
#               )
#    user.location << Faker::Address.longitude
#    user.location << Faker::Address.latitude
#
#    date = (DateTime.now + (rand * 7))
#    Day.create(date: date)
#     10.times do |i|
#       i % 2 == 0 ? tt = 0 : tt = 1
#       stop = date + (rand * 1)
#       id = rand(1..User.count)
#       Trip.create!(user_id: id, day_id: Day.last.id, trip_type: tt, timestamps: COORD.sample, stop: stop)
#     end
#    user.save
#   p "last email: #{user.email}"
#   p "users' password: 'banana'"
# end
#
# 2.times do |n|
#   u1 = User.find(n+1)
#   u2 = User.find(rand(1..10))
#   u1.friendships << u2
#   u2.friendships << u1
# end
#
# 5.times do |n|
#   u = User.order("RANDOM()").first
#   a = Admin.create!(user_id: u.id)
#   6.times do |n|
#     group = Group.create!(name: Faker::GameOfThrones.house,
#                     description: Faker::RickAndMorty.quote,
#                     admin_id: a.id
#                   )
#     UserGroup.create!(user_id: u.id, group_id: group.id)
#     3.times { group.users << User.order("RANDOM()").last }
#   end
# end
#
# #
# # COORD = [
# #          [[46.3625, 15.114444],[46.055556, 14.508333]],
# #          [[50.82413,  -104.95922], [50.82413, -104.95922]],
# #          [[-59.3068, 164.92105], [-58.2200, 164.99910]],
# #          [[-24.82067, -113.06858],[-25.25919, -116.92851]],
# #          [[-2.66268, -82.91891], [-8.66172, -162.63773]],
# #          [[29.98702,  -134.26584], [26.98321, -130.39952]]
# #        ]
