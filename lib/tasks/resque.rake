require 'resque/tasks'

namespace :resque do
  puts "Loading Rails environment for Resque"
  task :setup => :environment do
  	Dir["../../app/models/jobs/"].each do |file|
		  require file
		end
    ActiveRecord::Base.descendants.each { |klass|  klass.columns }
  end
end
