CarrierWave.configure do |config|

  if ENV['AWS_BUCKET'] and !Rails.env.test?
    config.storage    = :aws
    config.aws_bucket = ENV.fetch('AWS_BUCKET')
    config.aws_acl    = 'private'

    # Optionally define an asset host for configurations that are fronted by a
    config.asset_host = ENV['IMAGE_HOST'].present? ? ENV['IMAGE_HOST'] : "https://s3-#{ENV.fetch('AWS_REGION')}.amazonaws.com/#{config.aws_bucket}"
    
    # The maximum period for authenticated_urls is only 1 minute.
    config.aws_authenticated_url_expiration = 60 * 5

    config.aws_credentials = {
      access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
      region:            ENV.fetch('AWS_REGION') 
    }

  else
    config.enable_processing = false if Rails.env.test?
    config.storage = :file
  end
end
