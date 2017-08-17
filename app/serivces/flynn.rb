require 'open3'

class Flynn

  def initialize(app)
    @app = app
  end

  def self.get_apps
    apps = table_to_hash(`flynn apps`)
    system = %w(status dashboard taffy logaggregator docker receive gitreceive router blobstore mongodb mariadb redis discoverd flannel postgres controller)
    apps.select{|r| !system.detect{|k| r['NAME'].include? k}  }
  end

  def routes
    self.class.table_to_hash `flynn -a #{@app} route`
  end

  def resources
    self.class.table_to_hash `flynn -a #{@app} resource`
  end

  def backup_postgres
    tmp_file "flynn -a #{@app} pg dump"
  end

  def backup_mariadb
    tmp_file "flynn -a #{@app} mysql dump"
  end

  def backup_mongodb
    tmp_file "flynn -a #{@app} mongodb dump"
  end

  def backup_redis
    tmp_file "flynn -a #{@app} redis dump"
  end

  def backup_app
    tmp_file "flynn -a #{@app} export"
  end

  def update_ssl_route(acme_cert)
    cert = Tempfile.new(['cert','.pem'])
    key = Tempfile.new(['key','.pem'])
    cert.write acme_cert.cert_pem
    key.write acme_cert.private_pem
    
    cmd = "flynn -a #{@app} route update #{acme_cert.route.f_id} -c #{cert.path} -k #{key.path}"
    stdout, stderr, status = Open3.capture3(cmd)
    
    cert.unlink
    key.unlink

    [stdout, stderr].join
  end

  private

  def tmp_file cmd
    file = Tempfile.new(['tmp', '.tar'])
    `#{cmd} -f #{file.path}`
    file
  end

  def self.table_to_hash table
    rows = table.split("\n")
    keys = rows.shift.split(/\s{2,}/) 
    rows.map{|n| 
      values = n.split(/\s{2,}/) 
      keys.zip(values).to_h
    }
  end

end

