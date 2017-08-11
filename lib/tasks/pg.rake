namespace :pg do
  desc "Drop the postgresql connections"
  task :disconnect do
    conf = Rails.configuration.database_configuration[Rails.env]
    return unless conf['adapter'] == 'postgresql'
    db   = conf['database']
    cmd  = "psql postgres -c \"select pg_terminate_backend(pid) from pg_stat_activity where datname='#{db}'\""
    system(cmd)
  end

  desc "Add missing indexes to the table"
  task add_missing_sequences: :environment do

    # list tables
    tables = ActiveRecord::Base.connection.execute("select * from pg_tables where schemaname = 'public'")
    tables = tables.map{|r| r['tablename'] }.select{|t| t != 'schema_migrations' }

    # list sequences
    sequences = ActiveRecord::Base.connection.execute("SELECT c.relname FROM pg_class c WHERE c.relkind = 'S';")
    sequences = sequences.map{|r| r['relname'] }
    
    # add missing sequences
    tables.each do |table|
      seq_name = "#{table}_id_seq"
      if sequences.include?(seq_name)
        # already present
        puts "Table #{table} already has sequence #{seq_name}"
      else
        # add the missing
        ActiveRecord::Base.connection.execute("CREATE SEQUENCE #{seq_name};")
        ActiveRecord::Base.connection.execute("ALTER TABLE #{table} ALTER COLUMN id SET DEFAULT nextval('#{seq_name}');")
        puts "ADDED - Table #{table} now has sequence #{seq_name}"
      end

      # update the nextval
      ActiveRecord::Base.connection.execute("SELECT setval('#{seq_name}', COALESCE(max(id), 1)) FROM #{table};")
    end

  end
end