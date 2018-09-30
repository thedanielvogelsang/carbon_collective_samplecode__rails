web: bundle exec puma
worker: bundle exec sidekiq -c 25 -v -e production
web: bin/rails server -p $PORT -b 0.0.0.0
