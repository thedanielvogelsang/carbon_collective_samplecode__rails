# ----

desc "These rake tasks perform background work for our application
      (Userlogs, Region updates, and Snapshot creation) "

  # called from <AverageCalculatorJob> workers .perform_async method, after an
      # <electric, water, or gas > bill
      # has been created successfully in /api/v1/users/ folder
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

#  -----

  # called from heroku rake task Scheduler, every day at midnight
    # dependent on update_snapshots and write_to_userlogs tasks (below)
  task :update_snapshots_and_write_to_userlogs => [:update_snapshots, :write_to_userlogs] do
    puts '...midnight update complete'
  end

#  -----

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

  task :write_to_userlogs => :environment do
    puts "Writing to S3 Bucket"
      AwsService.new.create_new_logfile

    puts "...files logged to AWS bucket: \nAWS Login Info:\n
      IAM user_name: ‘sven’\n
      Password: SEE PROJECT OWNER FOR PASSWORD\n
      link: https://167120696907.signin.aws.amazon.com/console \n"
  end
