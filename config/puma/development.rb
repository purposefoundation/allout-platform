#!/usr/bin/env puma

# start puma with:
# RAILS_ENV=production bundle exec puma -C ./config/puma.rb

#require "active_record"
#cwd = 
#ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
#ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || YAML.load_file("#{cwd}/config/database.yml")[ENV["RACK_ENV"]])
#ActiveRecord::Base.verify_active_connections!

application_path = '/var/www/allout-platform'
railsenv = ENV['RACK_ENV']
threads 0, 32
activate_control_app
directory application_path
environment railsenv
daemonize false
pidfile "#{application_path}/tmp/pids/puma-#{railsenv}.pid"
state_path "#{application_path}/tmp/pids/puma-#{railsenv}.state"
stdout_redirect
"#{application_path}/log/puma-#{railsenv}.stdout.log"
"#{application_path}/log/puma-#{railsenv}.stderr.log"
bind "unix://#{application_path}/tmp/sockets/#{railsenv}.socket"