# config/puma.rb
threads ENV.fetch("MIN_PUMA_THREADS"){1},ENV.fetch("MAX_PUMA_THREADS"){1}
workers ENV.fetch("PUMA_WORKERS"){2}
preload_app!

on_worker_boot do
  require "active_record"
  cwd = File.dirname(__FILE__)+"/.."
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || YAML.load_file("#{cwd}/config/database.yml")[ENV["RAILS_ENV"]])
end
