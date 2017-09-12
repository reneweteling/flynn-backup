class AddTimestamps < ActiveRecord::Migration[5.1]
  def change
    add_column :acme_certs, :created_at, :datetime, default: nil, null: true
    add_column :acme_certs, :updated_at, :datetime, default: nil, null: true

    AcmeCert.update_all created_at: Time.now, updated_at: Time.now

    change_column_null :acme_certs, :created_at, false
    change_column_null :acme_certs, :updated_at, false
  end
end
