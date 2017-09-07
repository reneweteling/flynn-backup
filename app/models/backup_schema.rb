class BackupSchema < ApplicationRecord
  belongs_to :app
  belongs_to :resource, optional: true
  has_many :backups, dependent: :nullify

  enum backup_type: [:app, :mariadb, :mongodb, :postgres, :redis] 

  validates_presence_of :app, :days, :hours, :retention

  scope :enabled, -> { where(enabled: :true) }
  scope :pending_jobs, -> { enabled.where("backup_schemas.run_at isnull or now() > (backup_schemas.run_at + (backup_schemas.days || ' day ' || backup_schemas.hours || ' hour')::interval)") }


  def get_backup
    case backup_type.to_sym
    when :app
      Flynn.new(app.name).backup_app
    when :mariadb
      Flynn.new(app.name).backup_mariadb
    when :mongodb
      Flynn.new(app.name).backup_mongodb
    when :postgres
      Flynn.new(app.name).backup_postgres
    when :redis
      Flynn.new(app.name).backup_redis
    end
  end

  def post_backup s3path
    case backup_type.to_sym
    when :app
      Flynn.new(app.name).backup_app_to s3path
    when :mariadb
      Flynn.new(app.name).backup_mariadb_to s3path
    when :mongodb
      Flynn.new(app.name).backup_mongodb_to s3path
    when :postgres
      Flynn.new(app.name).backup_postgres_to s3path
    when :redis
      Flynn.new(app.name).backup_redis_to s3path
    end
  end


end
