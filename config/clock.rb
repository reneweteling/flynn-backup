require './config/boot'
require './config/environment'

Clockwork.every(5.minutes, "BackupJob") { BackupJob.set(wait: 1.minute).perform_later }