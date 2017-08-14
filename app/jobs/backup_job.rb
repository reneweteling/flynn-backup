class BackupJob < ApplicationJob
  
  def perform
    # log "Run #{Time.now}"
  end

  private

  def log(msg)
    `curl -X POST -H 'Content-type: application/json' --data '{"text":"#{msg}"}' https://hooks.slack.com/services/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`
  end
end