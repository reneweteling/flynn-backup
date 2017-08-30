class Route < ApplicationRecord
  belongs_to :app
  has_many :acme_certs, dependent: :destroy

  scope :http, -> { where("route ~ '^http:'") }
  scope :https, -> { where("route ~ '^https:'") }

  def to_s
    route
  end
end
