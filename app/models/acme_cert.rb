class AcmeCert < ApplicationRecord
  belongs_to :route
  belongs_to :app
  serialize :error, JSON
  validates_presence_of :email

  scope :expires_soon, -> { where(auth_verify_status: 'valid').where('expires_at < ?', Time.now + 1.month) }
  
  def common_name
    route.route.split(':').second
  end

  def domains
    [common_name]
  end

  def activate_certificate
    flynn = Flynn.new(app.name)
    acme_client = AcmeClient.new(self)

    flynn.ensure_acme_route(self)
    acme_client.get_challenge!
    sleep 1
    acme_client.get_status!
    sleep 1
    acme_client.get_certificate!
    sleep 1
    flynn.update_ssl_route(resource)
  end
end
