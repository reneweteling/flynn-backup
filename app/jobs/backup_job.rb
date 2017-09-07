class BackupJob < ApplicationJob
  
  def perform
    backup
  end

  private

  def backup
    BackupSchema.pending_jobs.each do |b|
      
      ext = b.resource ? '.dump' : '.tar'
      # create the backup with the tmp file
      backup = b.backups.create!(app: b.app, resource: b.resource, file: Tempfile.new(['backup', ext]))
      # stream the backup directly to s3
      file_size = b.post_backup backup.file.path
      backup.update!(file_size: file_size)
      # Remove items that are out of our retention scope
      b.app.backups.where(resource: b.resource).order(id: :desc).drop(b.retention).map(&:destroy!)

      # Set our run time at now
      b.update!(run_at: Time.now)
    end
  end

  def log(msg)
    `curl -X POST -H 'Content-type: application/json' --data '{"text":"#{msg}"}' https://hooks.slack.com/services/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`
  end
end