Clockwork.every(1.minute, "BackupJob") { system "cd /app && bundle exec bin/rails runner 'BackupJob::perform_later'" }