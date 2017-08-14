class MongodbResource < Resource
  def backup
    Flynn.new(app.name).backup_mongodb
  end
end
