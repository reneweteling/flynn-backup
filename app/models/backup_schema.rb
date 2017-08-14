class BackupSchema < ApplicationRecord
  belongs_to :app
  belongs_to :resource, optional: true
  has_many :backups, dependent: :nullify

  validates_presence_of :app, :days, :hours, :retention

  scope :pending_jobs, -> { where("backup_schemas.run_at isnull or now() > (backup_schemas.run_at + (backup_schemas.days || ' day ' || backup_schemas.hours || ' hour')::interval)") }
end
