class CertificateJob < ApplicationJob
  
  def perform
    prolong_certificates
  end

  private

  def prolong_certificates
    AcmeCert.expires_soon.each do |cert|

      flynn = Flynn.new(cert.app.name)
      acme_client = AcmeClient.new(cert)
  
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

end