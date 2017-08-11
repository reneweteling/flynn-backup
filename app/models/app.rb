class App < ApplicationRecord
  has_many :resources
  has_many :mariadb_resources
  has_many :mongodb_resources
  has_many :redis_resources
  has_many :postgres_resources
  has_many :routes
end
