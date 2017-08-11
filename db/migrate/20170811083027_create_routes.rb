class CreateRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :routes do |t|
      t.belongs_to :app, foreign_key: true
      t.string :f_id
      t.string :route
      t.string :service
      t.boolean :sticky
      t.boolean :leader
      t.string :path

      t.timestamps
    end
  end
end
