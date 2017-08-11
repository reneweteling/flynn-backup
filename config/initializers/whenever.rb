if Rails.env.production?
  puts "Update crontab"
  puts `whenever --update-crontab`
end