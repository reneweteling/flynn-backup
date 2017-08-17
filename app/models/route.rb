class Route < ApplicationRecord
  belongs_to :app

  def to_s
    route
  end
end
