desc "This task is called by the Heroku scheduler add-on"
task :update_snapshots => :environment do
  puts "Updating snapshots...."
    Country.all.each{|c| CountrySnapshot.take_snapshot(c) }
    Region.all.each{|r| RegionSnapshot.take_snapshot(r) }
    City.all.each{|c| CitySnapshot.take_snapshot(c) }
    Neighborhood.all.each{|n| NeighborhoodSnapshot.take_snapshot(n) }
    House.all.each{|h| HouseholdSnapshot.take_snapshot(h) }
  puts "Snapshots logged"
end
