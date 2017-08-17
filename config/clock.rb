require './config/boot'
require './config/environment'

# Run out backupper every 5 min
Clockwork.every(5.minutes, "BackupJob") { BackupJob.perform_later }

# Check if we need to extend a ssl certificate
Clockwork.every(1.day, "CertificateJob") { CertificateJob.perform_later }