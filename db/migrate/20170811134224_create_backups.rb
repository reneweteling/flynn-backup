class CreateBackups < ActiveRecord::Migration[5.1]
  def change
    create_table :backups do |t|
      t.belongs_to :app, foreign_key: true
      t.belongs_to :resource, foreign_key: true
      t.string :file

      t.timestamps
    end
  end
end
