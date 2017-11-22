require 'open3'

class Flynn

  FLYNN_APP = 'flynn-backup'

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

  def releases
    self.class.table_to_hash `flynn -a #{@app} release`
  end

  def delete_release(id)
    `flynn -a #{@app} release delete -y #{id}`
  end

  def delete_old_releases
    all_releases = releases
    # keep the last 2
    all_releases.shift
    all_releases.shift
    # delete the old ones
    all_releases.map{|r| delete_release(r['ID']) }
  end

  def backup_postgres
    tmp_file "flynn -a #{@app} pg dump", ".dump"
  end

  def backup_mariadb
    tmp_file "flynn -a #{@app} mysql dump", ".dump"
  end

  def backup_mongodb
    tmp_file "flynn -a #{@app} mongodb dump", ".dump"
  end

  def backup_redis
    tmp_file "flynn -a #{@app} redis dump", ".dump"
  end

  def backup_app
    tmp_file "flynn -a #{@app} export"
  end

  def backup_postgres_to s3path
    to_s3 s3path, "flynn -a #{@app} pg dump"
  end

  def backup_mariadb_to s3path
    to_s3 s3path, "flynn -a #{@app} mysql dump"
  end

  def backup_mongodb_to s3path
    to_s3 s3path, "flynn -a #{@app} mongodb dump"
  end

  def backup_redis_to s3path
    to_s3 s3path, "flynn -a #{@app} redis dump"
  end

  def backup_app_to s3path
    to_s3 s3path, "flynn -a #{@app} export"
  end

  def ensure_acme_route acme_cert
    flynn_routes = Flynn.new(FLYNN_APP).routes
    cert_route = acme_cert.route.route.split(':').second
    
    unless flynn_routes.detect{|route| route['ROUTE'].split(':').second == cert_route }
      # route not present on flynn
      `flynn -a #{FLYNN_APP} route add http #{cert_route}/.well-known/acme-challenge/`
    end
  end

  def update_ssl_route(acme_cert)
    cert = Tempfile.new(['cert','.pem'])
    key = Tempfile.new(['key','.pem'])

    File.open(cert.path, "w+") do |f|
      f.write(acme_cert.fullchain_pem)
    end
    
    File.open(key.path, "w+") do |f|
      f.write(acme_cert.private_pem)
    end
    
    cmd = "flynn -a #{@app} route update #{acme_cert.route.f_id} -c #{cert.path} -k #{key.path}"

    stdout, stderr, status = Open3.capture3(cmd)
    
    cert.unlink
    key.unlink

    [stdout, stderr].join
  end

  private

  def tmp_file cmd, ext = '.tar'
    file = Tempfile.new(['tmp', ext])
    `#{cmd} -f #{file.path}`
    file
  end

  def to_s3 s3path, cmd
    aws_cred = "AWS_ACCESS_KEY_ID=#{ENV.fetch('AWS_ACCESS_KEY_ID')} AWS_SECRET_ACCESS_KEY=#{ENV.fetch('AWS_SECRET_ACCESS_KEY')} AWS_DEFAULT_REGION=#{ENV.fetch('AWS_DEFAULT_REGION')}"

    s3path = "s3://#{ENV.fetch('AWS_BUCKET')}/#{s3path}"
    `#{cmd} | #{aws_cred} aws s3 cp - #{s3path}`
    size = `#{aws_cred} aws s3 ls #{s3path}`
    filesize = size.split(/\s{2,}/)[1].split(' ')[0].to_i
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