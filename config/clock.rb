require './config/boot'
require './config/environment'

Clockwork.every(5.minutes, "BackupJob") { BackupJob.delay(run_at: 1.minutes.from_now).perform }