class PostgresResource < Resource
  def backup
    Flynn.new(app.name).backup_postgres
  end
end
