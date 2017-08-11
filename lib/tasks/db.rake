namespace :db do

  desc "Rebuild db using migrations (development only)"
  task :rebuild do
    raise "WTF!!! dude only in development!!!" unless Rails.env.development?
    `rm -rf public/uploads`
    system("rake pg:disconnect RAILS_ENV=test")
    Rake::Task["pg:disconnect"].invoke
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
  end

  # desc "Rebuild db from prod.dump (development only)"
  # task :rebuild_local do
  #   raise "WTF!!! dude only in development!!!" unless Rails.env.development?
  #   `rm -rf public/uploads`
  #   Rake::Task["pg:disconnect"].invoke
  #   Rake::Task["db:drop"].invoke
  #   Rake::Task["db:create"].invoke
  #   `pg_restore -d revolution9_development --disable-triggers --no-acl --no-owner --username=postgres zooi/prod.dump`
  #   Rake::Task["db:migrate"].invoke
  #   ActiveRecord::Base.connection.execute("update partners set domain = replace(domain, '.com', '.com')")
  #   ActiveRecord::Base.connection.execute("update artists set email = concat('dev-artist', id, '@revolve-music.dev')")
  # end

end
