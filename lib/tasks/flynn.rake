namespace :flynn do 
  task rebuild_local: :environment do 

    raise "WTF!!! dude only in development!!!" unless Rails.env.development?
    system("rake pg:disconnect RAILS_ENV=test")
    Rake::Task["pg:disconnect"].invoke
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke

    db = Rails.configuration.database_configuration['development']['database']

    run_command "flynn pg dump -f prod.dump"
    run_command "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d #{db} prod.dump"
    run_command "rm prod.dump"

    Rake::Task["db:migrate"].invoke
  end 

  def run_command(cmd)
    puts "Running: '#{cmd}'"
    puts `#{cmd}`
  end
end