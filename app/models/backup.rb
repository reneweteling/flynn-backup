class Backup < ApplicationRecord
  belongs_to :app
  belongs_to :resource
  belongs_to :backup_schema, counter_cache: true

  mount_uploader :file, BaseUploader

  def file=(new_file)
    super new_file

    if path = new_file.path
      self.file_size = File.size(path)
    end
  end
end
