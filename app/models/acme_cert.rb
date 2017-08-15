class AcmeCert < ApplicationRecord
  belongs_to :app
  serialize :error, JSON
end
