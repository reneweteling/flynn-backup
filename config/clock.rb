require './config/boot'
require './config/environment'

Clockwork.every(1.minute, "BackupJob") { system "bundle exec bin/rails runner 'BackupJob.delay(run_at: 10.seconds.from_now)'" }