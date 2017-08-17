namespace :flynn do 
  task test: :environment do 
    cert = AcmeCert.new( app: App.first, email: 'rene@weteling.com', common_name: 'weteling.com', domains: ['*.weteling.com', '*.hosting.weteling.com'])

    cert = AcmeCert.first

    client = AcmeClient.new(cert)
    client.test
    # client.get_challenge!

  end 
end





