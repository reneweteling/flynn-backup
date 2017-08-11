class Resource < ApplicationRecord
  belongs_to :app
  has_many :backups, dependent: :nullify

  def to_s
    provider_name
  end
end
