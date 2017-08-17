class CreateAcmeCert < ActiveRecord::Migration[5.1]
  def change
    create_table :acme_certs do |t|
      t.belongs_to :route, foreign_key: true
      t.string :email
      t.text :private_key
      t.string :status
      t.string :auth_uri
      t.string :token
      t.string :filename
      t.text :file_content
      t.string :challenge_verify_status
      t.string :auth_verify_status
      t.text :error
      t.text :private_pem
      t.text :cert_pem
      t.text :chain_pem
      t.text :fullchain_pem
      t.timestamp :expires_at
      t.timestamp :issued_at
    end
  end
end
