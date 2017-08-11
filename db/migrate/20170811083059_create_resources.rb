class CreateResources < ActiveRecord::Migration[5.1]
  def change
    create_table :resources do |t|
      t.belongs_to :app, foreign_key: true
      t.string :type
      t.string :f_id
      t.string :provider_id
      t.string :provider_name

      t.timestamps
    end
  end
end
