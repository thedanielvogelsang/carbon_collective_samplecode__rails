require 'rake'

Sidekiq.configure_client do |config|
  config.redis = {size: 3, url: ENV['REDISCLOUD_URL']}
end
Sidekiq.configure_server do |config|
  config.redis = {size: 22, url: ENV['REDISCLOUD_URL']}
end

class AverageCalculatorJob
  include Sidekiq::Worker
  # sidekiq_options retry: false

  def perform
    puts "Worker task started...\n"
    puts 'Updating household data'
    House.find_each{|h| h.update_data}

    puts 'Updating neighborhood data'
    Neighborhood.find_each{|n| n.update_data }

    puts 'Updating city data'
    City.find_each{|c| c.update_data }

    puts 'Updating county data'
    County.find_each{|c| c.update_data }

    puts 'Updating region data'
    Region.find_each{|r| r.update_data }

    puts 'Updating country data'
    Country.find_each{|c| c.update_data }

    puts "Updating global stats"
    Global.first.update_data

    puts "...done.\n"

        puts "task completed\n"

    # THINGS THAT DIDNT WORK:
      # `rake -f #{Rails.root.join("Rakefile")} #{@task}`
      # `heroku run rake #{@task}`
  end
end
