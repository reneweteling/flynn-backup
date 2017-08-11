namespace :flynn do 
  task test: :environment do 
    apps = Flynn.get_apps

    apps.each do |a|
      flynn = Flynn.new(a['NAME'])

      # get our app
      app = App.find_or_initialize_by(f_id: a['ID'])
      app.name = a['NAME']

      # link resources
      flynn.resources.each do |r|
        resource = app.resources.find_or_initialize_by(f_id: r['ID'])
        resource.provider_id = r['PROVIDER_ID']
        resource.provider_name = r['PROVIDER_NAME']
        resource.type = "#{resource.provider_name}_resource".camelize
      end

      # link routes
      flynn.routes.each do |r|
        route = app.routes.find_or_initialize_by(f_id: r['ID'])
        route.route = r['ROUTE']
        route.service = r['SERVICE']
        route.sticky = r['STICKY']
        route.leader = r['LEADER']
        route.path = r['PATH']
      end

      app.save!

    end

  end 
end





