require 'openssl'
require 'acme-client'

class AcmeClient

  def initialize(cert)
    @cert = cert
    # We need an ACME server to talk to, see github.com/letsencrypt/boulder
    # WARNING: This endpoint is the production endpoint, which is rate limited and will produce valid certificates.
    # You should probably use the staging endpoint for all your experimentation:
    @endpoint = 'https://acme-staging.api.letsencrypt.org/'
    @endpoint = 'https://acme-v01.api.letsencrypt.org/' if Rails.env.production?
  end

  def get_challenge!
    return if @cert.auth_uri.present?

    # We're going to need a private key.
    @cert.private_key = OpenSSL::PKey::RSA.new(4096).to_s
    
    # Initialize the client
    client = Acme::Client.new(private_key: OpenSSL::PKey::RSA.new(@cert.private_key), endpoint: @endpoint, connection_options: { request: { open_timeout: 15, timeout: 15 } })

    # If the private key is not known to the server, we need to register it for the first time.
    registration = client.register(contact: "mailto:#{@cert.email}")
    
    # You may need to agree to the terms of service (that's up the to the server to require it or not but boulder does by default)
    registration.agree_terms

    authorization = client.authorize(domain: @cert.common_name)

    # If authorization.status returns 'valid' here you can already get a certificate
    # and _must not_ try to solve another challenge.
    @cert.status = authorization.status # => 'pending'

    # You can can store the authorization's URI to fully recover it and
    # any associated challenges via Acme::Client#fetch_authorization.
    @cert.auth_uri = authorization.uri # => '...'

    # This example is using the http-01 challenge type. Other challenges are dns-01 or tls-sni-01.
    challenge = authorization.http01

    # The http-01 method will require you to respond to a HTTP request.

    # You can retrieve the challenge token
    @cert.token = challenge.token # => "some_token"

    # You can retrieve the expected path for the file.
    @cert.filename = challenge.filename # => ".well-known/acme-challenge/:some_token"

    # You can generate the body of the expected response.
    @cert.file_content = challenge.file_content # => 'string token and JWK thumbprint'

    # Once you are ready to serve the confirmation request you can proceed.
    @cert.challenge_verify_status = challenge.authorization.verify_status # => 'pending'
    

    @cert.save!
  end

  def get_status!
    return unless @cert.auth_uri

    client = Acme::Client.new(private_key: OpenSSL::PKey::RSA.new(@cert.private_key), endpoint: @endpoint, connection_options: { request: { open_timeout: 15, timeout: 15 } })
   
    # Load a challenge based on stored authorization URI. This is only required if you need to reuse a challenge as outlined above.
    challenge = client.fetch_authorization(@cert.auth_uri).http01
    challenge.request_verification if @cert.challenge_verify_status == 'pending'



    # client.fetch_authorization(@cert.auth_uri).expires

    # Wait a bit for the server to make the request, or just blink. It should be fast.
    sleep(1)

    @cert.error = [] if @cert.error.blank?

    # Rely on authorization.verify_status more than on challenge.verify_status,
    # if the former is 'valid' you can already issue a certificate and the status of
    # the challenge is not relevant and in fact may never change from pending.
    @cert.challenge_verify_status = challenge.authorization.verify_status # => 'valid'
    @cert.error << challenge.error if challenge.error.present?

    # If authorization.verify_status is 'invalid', you can get at the error
    # message only through the failed challenge.
    authorization = client.authorize(domain: @cert.common_name)
    @cert.auth_verify_status = authorization.verify_status # => 'invalid'
    @cert.error << authorization.http01.error if authorization.http01.error.present?

    @cert.save!
  end

  def get_certificate!
    return unless @cert.challenge_verify_status == 'valid'

    client = Acme::Client.new(private_key: OpenSSL::PKey::RSA.new(@cert.private_key), endpoint: @endpoint, connection_options: { request: { open_timeout: 15, timeout: 15 } })
    # We're going to need a certificate signing request. If not explicitly
    # specified, the first name listed becomes the common name.
    csr = Acme::Client::CertificateRequest.new(names: @cert.domains)

    # We can now request a certificate. You can pass anything that returns
    # a valid DER encoded CSR when calling to_der on it. For example an
    # OpenSSL::X509::Request should work too.
    certificate = client.new_certificate(csr) # => #<Acme::Client::Certificate ....>

    # Save the certificate and the private key to files
    @cert.private_pem = certificate.request.private_key.to_pem
    @cert.cert_pem = certificate.to_pem
    @cert.chain_pem = certificate.chain_to_pem
    @cert.fullchain_pem = certificate.fullchain_to_pem
    @cert.issued_at = certificate.x509.not_before
    @cert.expires_at = certificate.x509.not_after

    @cert.save!
  end

end
