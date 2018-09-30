require 'rake'

# Sidekiq.configure_client do |config|
#   config.redis = {db: 0}
# end
# Sidekiq.configure_server do |config|
#   config.redis = {db: 0}
# end

class AverageCalculatorJob
  include Sidekiq::Worker
  # sidekiq_options retry: false

  def perform
    puts 'worker started'
    @task = "update_data"
    `rake -f #{Rails.root.join("Rakefile")} #{@task}`
  end
end
