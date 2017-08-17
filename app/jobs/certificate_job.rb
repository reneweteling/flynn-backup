class CertificateJob < ApplicationJob
  
  def perform
    prolong_certificates
  end

  private

  def prolong_certificates
    AcmeCert.expires_soon.each do |cert|
      # get a new certificate
      AcmeClient.new(cert).get_certificate!
      # add it to our flynn route
      Flynn.new(cert.app.name).update_ssl_route(cert)
    end
  end

end