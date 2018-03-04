require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)

z = [80204, 80205, 80207, 80209, 80216, 80218, 80202, 80211, 80220]
z.each{ |zc| Zipcode.create!(zipcode: zc) }

COORD = [
         [[46.3625, 15.114444],[46.055556, 14.508333]],
         [[50.82413,  -104.95922], [50.82413, -104.95922]],
         [[-59.3068, 164.92105], [-58.2200, 164.99910]],
         [[-24.82067, -113.06858],[-25.25919, -116.92851]],
         [[-2.66268, -82.91891], [-8.66172, -162.63773]],
         [[29.98702,  -134.26584], [26.98321, -130.39952]]
       ]


10.times do |n|
  user = User.create!(
                first: Faker::HarryPotter.character.split(/\W/)[0],
                last: Faker::LordOfTheRings.character.split(/\W/)[0],
                email: Faker::Internet.email,
                username:"user#{n}",
                password: 'banana',
                zipcode_id: Zipcode.order("RANDOM()").last.id,
                school: Faker::HarryPotter.house,
                workplace: Faker::Company.name,
                location: Array.new,
                url: Faker::Avatar.image
              )
   user.location << Faker::Address.longitude
   user.location << Faker::Address.latitude
   18.times do |i|
     t_name = Faker::Compass.direction + Faker::Compass.azimuth
     date = (DateTime.now - (rand * 3))
     Day.create(date: date)
     # fix trip.timestamps array bug
     i % 2 == 0 ? tt = 0 : tt = 1
     stop = DateTime.now + (rand * 1)
     id = rand(1..User.count)
     Trip.create(user_id: id, day_id: Day.last.id, trip_type: tt, timestamps: COORD.sample, stop: stop)
   end
   user.save
  p "last username: #{user.username}"
  p "users' password: 'banana'"
end

2.times do |n|
  u1 = User.find(n+1)
  u2 = User.find(rand(1..10))
  u1.friendships << u2
  u2.friendships << u1
end

5.times do |n|
  u = User.order("RANDOM()").first
  a = Admin.create!(user_id: u.id)
  6.times do |n|
    group = Group.create!(name: Faker::GameOfThrones.house,
                    description: Faker::RickAndMorty.quote,
                    admin_id: a.id
                  )
    UserGroup.create!(user_id: u.id, group_id: group.id)
    3.times { group.users << User.order("RANDOM()").last }
  end
end
