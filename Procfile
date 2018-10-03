web: bundle exec puma
worker: bundle exec sidekiq -c 20 -t 25
web: bin/rails server -p $PORT -b 0.0.0.0
