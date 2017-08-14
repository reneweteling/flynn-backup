class Backup < ApplicationRecord
  belongs_to :app
  belongs_to :resource, optional: true
  belongs_to :backup_schema, counter_cache: true, optional: true

  mount_uploader :file, BaseUploader

  def file=(new_file)
    super new_file

    if path = new_file.path
      self.file_size = File.size(path)
    end
  end
end
