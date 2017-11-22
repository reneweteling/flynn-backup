class CertificateJob < ApplicationJob
  
  def perform
    prolong_certificates
  end

  private

  def prolong_certificates
    AcmeCert.expires_soon.each do |cert|
      cert.activate_certificate
    end
  end

end