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
    puts 'worker started'
    @task = "update_data"
    `rake -f #{Rails.root.join("Rakefile")} #{@task}`
  end
end
