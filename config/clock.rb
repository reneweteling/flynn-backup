require './config/boot'
require './config/environment'

Clockwork.every(5.minutes, "BackupJob") { BackupJob.perform_later }