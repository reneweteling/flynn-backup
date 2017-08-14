require './config/boot'
require './config/environment'

Clockwork.every(1.minute, "BackupJob") { BackupJob.delay(run_at: 10.seconds.from_now) }