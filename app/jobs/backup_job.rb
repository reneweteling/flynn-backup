class BackupJob < ApplicationJob
  
  def perform
    backup
  end

  private

  def backup
    BackupSchema.pending_jobs.each do |b|
      
      # create the backup
      b.backups.create!(app: b.app, resource: b.resource, file: b.get_backup)
      
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