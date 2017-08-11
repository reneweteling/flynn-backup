web: ROLE=app bundle exec puma -C config/puma.rb
worker: ROLE=worker bin/delayed_job start
clock: bundle exec clockwork config/clock.rb