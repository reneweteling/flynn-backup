class MariadbResource < Resource
  def backup
    Flynn.new(app.name).backup_mariadb
  end
end
