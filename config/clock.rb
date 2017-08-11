require File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'boot'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'environment'))

Clockwork.every(1.minute, "BackupJob") { system "bundle exec bin/rails runner 'BackupJob::perform_later'" }