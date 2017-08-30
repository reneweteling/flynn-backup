class Route < ApplicationRecord
  belongs_to :app
  has_many :acme_certs, dependent: :destroy

  validates_presence_of :f_id

  scope :http, -> { where("route ~ '^http:'") }
  scope :https, -> { where("route ~ '^https:'") }

  def to_s
    route
  end
end
