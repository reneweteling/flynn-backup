class AddAppToAcmeCerts < ActiveRecord::Migration[5.1]
  def change
    add_reference :acme_certs, :app, foreign_key: true
    add_reference :acme_certs, :ssl_route, foreign_key:  {to_table: :routes}
  end
end
