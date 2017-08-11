class FlynnSync
  def self.sync
    apps = Flynn.get_apps

    apps.each do |a|
      flynn = Flynn.new(a['NAME'])

      # get our app
      app = App.find_or_initialize_by(f_id: a['ID'])
      app.name = a['NAME']

      # link resources
      flynn.resources.each do |r|
        resource = app.resources.find_or_initialize_by(f_id: r['ID'])
        resource.provider_id = r['Provider ID']
        resource.provider_name = r['Provider Name']
        resource.type = "#{resource.provider_name}_resource".camelize
        resource.save!
      end

      # link routes
      flynn.routes.each do |r|
        route = app.routes.find_or_initialize_by(f_id: r['ID'])
        route.route = r['ROUTE']
        route.service = r['SERVICE']
        route.sticky = r['STICKY']
        route.leader = r['LEADER']
        route.path = r['PATH']
        route.save!
      end

      app.save!

      # remove orphans
      app.resources.where.not(f_id: flynn.resources.map{|f| f['ID'] }).destroy_all
      app.routes.where.not(f_id: flynn.routes.map{|f| f['ID'] }).destroy_all
    end

  end
end