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

  def backup_pg
    `flynn -a #{@app} pg dump`
  end

  def backup_mysql
    `flynn -a #{app} dump`
  end

  def backup_app
    `flynn -a #{@app} export`
  end

  private

  def self.table_to_hash table
    rows = table.split("\n")
    keys = rows.shift.split(/\s{2,}/) 
    rows.map{|n| 
      values = n.split(/\s{2,}/) 
      keys.zip(values).to_h
    }
  end

end