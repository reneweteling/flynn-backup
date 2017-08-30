class Resource < ApplicationRecord
  belongs_to :app
  has_many :backups, dependent: :nullify
  has_many :backup_schemas, dependent: :nullify

  def to_s
    provider_name
  end
end
