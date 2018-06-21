desc "This task is called by the Heroku scheduler add-on"
# task :update_snapshots => :environment do
#
# end

task :update_data => :environment do
  puts 'Updating country data'
  Country.all.each{|c| c.update_data }

  puts 'Updating region data'
  Region.all.each{|r| r.update_data }

  puts 'Update county data'
  County.all.each{|c| c.update_data }

  puts 'Updating city data'
  City.all.each{|c| c.update_data }

  puts 'Updating neighborhood data'
  Neighborhood.all.each{|n| n.update_data }

  puts "Updating snapshots...."
    Country.all.each{|c| CountrySnapshot.take_snapshot(c) }
    Region.all.each{|r| RegionSnapshot.take_snapshot(r) }
    County.all.each{|c| CountySnapshot.take_snapshot(c) }
    City.all.each{|c| CitySnapshot.take_snapshot(c) }
    Neighborhood.all.each{|n| NeighborhoodSnapshot.take_snapshot(n) }
    House.all.each{|h| HouseholdSnapshot.take_snapshot(h) }
  puts "Snapshots logged"

  puts '...done'
end
