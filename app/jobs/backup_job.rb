class BackupJob < ApplicationJob
  
  def perform
    backup
  end

  private

  def backup
    BackupSchema.pending_jobs.each do |b|
      
      # backup the apps
      backup = b.backups.new(app: b.app)
      if b.resource.present?
        backup.resource = b.resource
        backup.file = b.resource.backup
      else
        backup.file = Flynn.new(b.app.name).backup_app
      end
      backup.save!

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