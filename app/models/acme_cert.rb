class AcmeCert < ApplicationRecord
  belongs_to :route
  belongs_to :app
  serialize :error, JSON
  
  validates_presence_of :email
  after_create :ensure_acme_route

  scope :expires_soon, -> { where(auth_verify_status: 'valid').where('expires_at < ?', Time.now + 1.month) }
  
  def common_name
    route.route.split(':').second
  end

  def domains
    [common_name]
  end

  private 

  def ensure_acme_route
    Flynn.new(app.name).ensure_acme_route(self)
  end
end
