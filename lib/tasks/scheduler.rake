desc "This task is called by the Heroku scheduler add-on"
task :update_snapshots => :environment do
  puts "Updating snapshots...."
    Country.joins(:users).distinct.each{|c| CountrySnapshot.take_snapshot(c) }
    Region.joins(:users).distinct.each{|r| RegionSnapshot.take_snapshot(r) }
    County.joins(:users).distinct.each{|c| CountySnapshot.take_snapshot(c) }
    City.joins(:users).distinct.each{|c| CitySnapshot.take_snapshot(c) }
    Neighborhood.joins(:users).distinct.each{|n| NeighborhoodSnapshot.take_snapshot(n) }
    House.joins(:users).distinct.each{|h| HouseholdSnapshot.take_snapshot(h) }
  puts "Snapshots logged"
end

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

  puts '...done'
end

task :write_to_userlogs => :environment do
  puts "Writing to S3 Bucket"
    AwsService.new.create_new_logfile

  puts '...done'
end

task :update_snapshots_and_write_to_userlogs => [:update_snapshots, :write_to_userlogs] do
  puts '...midnight update complete'
end
