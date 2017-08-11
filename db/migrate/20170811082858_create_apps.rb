class CreateApps < ActiveRecord::Migration[5.1]
  def change
    create_table :apps do |t|
      t.string :f_id
      t.string :name

      t.timestamps
    end
  end
end
