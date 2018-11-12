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
    puts "Worker started\n"
    task = :update_data
    app = Rake.application
      app.init
      app.add_import Rails.root.join("Rakefile")
      # this loads the Rakefile and other imports
      app.load_rakefile
    # this queues and invokes the task
      puts "task invoked"
        app[task].invoke
        puts "task completed"

    # THINGS THAT DIDNT WORK:
      # `rake -f #{Rails.root.join("Rakefile")} #{@task}`
      # `heroku run rake #{@task}`
  end
end
