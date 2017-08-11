web: ROLE=app bundle exec puma -C config/puma.rb
worker: ROLE=worker bin/rake jobs:work
clock: bundle exec clockwork config/clock.rb