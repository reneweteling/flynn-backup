class CreateAcmeCert < ActiveRecord::Migration[5.1]
  def change
    create_table :acme_certs do |t|
      t.belongs_to :app, foreign_key: true
      t.string :email
      t.text :private_key
      t.string :domain
      t.string :status
      t.string :auth_uri
      t.string :token
      t.string :filename
      t.text :file_content
      t.string :challange_verify_status
      t.string :auth_verify_status
      t.text :error
    end
  end
end
