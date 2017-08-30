class App < ApplicationRecord
  has_many :resources, dependent: :destroy
  has_many :mariadb_resources, dependent: :destroy
  has_many :mongodb_resources, dependent: :destroy
  has_many :redis_resources, dependent: :destroy
  has_many :postgres_resources, dependent: :destroy

  has_many :routes, dependent: :destroy
  has_many :backup_schemas, dependent: :destroy
  has_many :backups, dependent: :nullify
  has_many :acme_certs, dependent: :destroy

  accepts_nested_attributes_for :resources, reject_if: :all_blank
  accepts_nested_attributes_for :routes, reject_if: :all_blank
  accepts_nested_attributes_for :backup_schemas, reject_if: :all_blank, allow_destroy: true
end
