class CreateBackupSchemas < ActiveRecord::Migration[5.1]
  def change
    create_table :backup_schemas do |t|
      t.belongs_to :app, foreign_key: true
      t.belongs_to :resource, foreign_key: true
      t.integer :days
      t.integer :hours
      t.integer :retention
      t.boolean :enabled
      t.integer :backups_count
      t.timestamp :run_at
      
      t.timestamps
    end
  end
end
