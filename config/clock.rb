require 'config/boot'
require 'config/environment'

Clockwork.every(1.minute, "BackupJob") { system "bundle exec bin/rails runner 'BackupJob::perform_later'" }