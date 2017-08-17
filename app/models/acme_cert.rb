class AcmeCert < ApplicationRecord
  belongs_to :route
  has_one :app, through: :route
  serialize :error, JSON
  
  validates_presence_of :email

  scope :expires_soon, -> { where(auth_verify_status: 'valid').where('expires_at < ?', Time.now - 1.week) }
  
  def common_name
    route.route.split(':').second
  end

  def domains
    [common_name]
  end
end
