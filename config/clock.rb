require './config/boot'
require './config/environment'

Clockwork.every(1.minute, "BackupJob") { BackupJob.perform_later }