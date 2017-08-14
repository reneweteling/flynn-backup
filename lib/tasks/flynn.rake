namespace :flynn do 
  task test: :environment do 
    BackupJob.perform_now
  end 
end





