class RedisResource < Resource
  def backup
    Flynn.new(app.name).backup_redis
  end
end
