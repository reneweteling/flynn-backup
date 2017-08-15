namespace :flynn do 
  task test: :environment do 

    require 'openssl'
    require 'acme-client'

    cert = AcmeCert.new( app: App.first, email: 'rene@weteling.com', domain: 'hosting.weteling.com' )

    # We're going to need a private key.
    cert.private_key = private_key = OpenSSL::PKey::RSA.new(4096)
    
    # We need an ACME server to talk to, see github.com/letsencrypt/boulder
    # WARNING: This endpoint is the production endpoint, which is rate limited and will produce valid certificates.
    # You should probably use the staging endpoint for all your experimentation:
    endpoint = 'https://acme-staging.api.letsencrypt.org/'
    # endpoint = 'https://acme-v01.api.letsencrypt.org/'

    # Initialize the client
    client = Acme::Client.new(private_key: private_key, endpoint: endpoint, connection_options: { request: { open_timeout: 15, timeout: 15 } })

    # If the private key is not known to the server, we need to register it for the first time.
    registration = client.register(contact: "mailto:#{cert.email}")
    
    # You may need to agree to the terms of service (that's up the to the server to require it or not but boulder does by default)
    registration.agree_terms

    authorization = client.authorize(domain: cert.domain)

    # If authorization.status returns 'valid' here you can already get a certificate
    # and _must not_ try to solve another challenge.
    cert.status = authorization.status # => 'pending'

    # You can can store the authorization's URI to fully recover it and
    # any associated challenges via Acme::Client#fetch_authorization.
    cert.auth_uri = authorization.uri # => '...'

    # This example is using the http-01 challenge type. Other challenges are dns-01 or tls-sni-01.
    challenge = authorization.http01

    # The http-01 method will require you to respond to a HTTP request.

    # You can retrieve the challenge token
    cert.token = challenge.token # => "some_token"

    # You can retrieve the expected path for the file.
    cert.filename = challenge.filename # => ".well-known/acme-challenge/:some_token"

    # You can generate the body of the expected response.
    cert.file_content = challenge.file_content # => 'string token and JWK thumbprint'

    # You are notver required to send a Content-Type. This method will return the right Content-Type should you decide to include one.
    # challenge.content_type

    # Save the file. We'll create a public directory to serve it from, and inside it we'll create the challenge file.
    # FileUtils.mkdir_p( File.join( 'public', File.dirname( challenge.filename ) ) )

    # We'll write the content of the file
    # File.write( File.join( 'public', challenge.filename), challenge.file_content )

    # Optionally save the authorization URI for use at another time (eg: by a background job processor)
    # File.write('authorization_uri', authorization.uri)

    # The challenge file can be served with a Ruby webserver.
    # You can run a webserver in another console for that purpose. You may need to forward ports on your router.
    #
    # $ ruby -run -e httpd public -p 8080 --bind-address 0.0.0.0

    # Load a challenge based on stored authorization URI. This is only required if you need to reuse a challenge as outlined above.
    challenge = client.fetch_authorization(cert.auth_uri).http01

    cert.save!

    cert.error ||= []

    # Once you are ready to serve the confirmation request you can proceed.
    puts challenge.request_verification # => true
    cert.challange_verify_status = challenge.authorization.verify_status # => 'pending'

    # Rely on authorization.verify_status more than on challenge.verify_status,
    # if the former is 'valid' you can already issue a certificate and the status of
    # the challenge is not relevant and in fact may never change from pending.
    cert.challange_verify_status = challenge.authorization.verify_status # => 'valid'
    cert.error << challenge.error if challenge.error.present?

    # If authorization.verify_status is 'invalid', you can get at the error
    # message only through the failed challenge.
    cert.auth_verify_status = authorization.verify_status # => 'invalid'
    cert.error << authorization.http01.error if authorization.http01.error.present?

    cert.save!

  end 
end





