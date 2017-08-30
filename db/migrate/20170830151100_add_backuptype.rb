class AddBackuptype < ActiveRecord::Migration[5.1]
  def change
    add_column :backup_schemas, :backup_type, :integer, null: false, default: 0
    add_column :backups, :backup_type, :integer, null: false, default: 0
  end
end
