# job_type :runner,  "/etc/profile.d/rails_env.sh && cd :path && bundle exec bin/rails runner ':task' :output"

every 1.minute do 
  runner "BackupJob::perform_now"
end