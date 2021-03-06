Dir["../../app/models/jobs/*.rb"].each { |file| require file }
require 'resque'
require 'resque-loner'
require 'resque-honeybadger'
require 'resque-retry'
require 'resque_scheduler'
require 'resque_scheduler/server'

require 'resque/failure/multiple'
require 'resque/failure/redis'

Resque.redis = ENV['REDIS_URL'] || 'localhost'
Resque.redis.namespace = "resque:platform"
Resque.logger = Rails.logger


Resque.after_fork = Proc.new do
  ActiveRecord::Base.verify_active_connections!
  #Rails.logger.auto_flushing = true
end

# If you don't already do `Honeybadger.configure` elsewhere.
Resque::Failure::Honeybadger.configure do |config|
  config.api_key = ENV.fetch("HONEYBADGER_API_KEY"){'1e93decd'}
end

Resque::Failure::MultipleWithRetrySuppression.classes = [Resque::Failure::Redis, Resque::Failure::Honeybadger]
Resque::Failure.backend =  Resque::Failure::MultipleWithRetrySuppression

Resque.schedule = YAML.load_file('lib/resque_schedule.yml')