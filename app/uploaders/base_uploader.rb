class BaseUploader < CarrierWave::Uploader::Base

  def cache_dir
    "uploads/tmp/#{store_dir}"
  end

  def filename
    # RMW: check the role, if its the worker (ROLE=worker) we dont want to bust the cache
    if original_filename.present? and ENV['ROLE'] != 'worker'
      "#{secure_token}.#{file.extension}" 
    else
      super
    end
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  protected

  def secure_token(length=8)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end

end