require './config/boot'
require './config/environment'

Clockwork.every(1.hour, "BackupJob") { BackupJob.perform_later }