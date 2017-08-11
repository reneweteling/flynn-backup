class Backup < ApplicationRecord
  belongs_to :app
  belongs_to :resource
end
