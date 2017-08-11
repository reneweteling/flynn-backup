class BackupSchema < ApplicationRecord
  belongs_to :app
  belongs_to :resource, optional: true

  validates_presence_of :app, :days, :hours, :retention
end
