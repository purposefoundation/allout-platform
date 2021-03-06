source 'https://rubygems.org'
ruby '2.1.1'

gem 'rails', '~>3.2.14'
gem 'mysql2', '0.3.11'
gem 'haml'
#gem 'sprockets', '~>2.1.2'
gem 'uuid'

gem 'json', '~> 1.7.7'

gem 'rb-readline'
gem 'rubyzip',  "~> 0.9.9"
gem 'yui-compressor', :git => "git://github.com/oleander/ruby-yui-compressor.git", :require  => "yui/compressor"
gem 'will_paginate' #, '~>3.0.3'
gem 'paranoia'
gem 'acts_as_list'
gem "skylight"
gem 'sendgrid' #, '0.1.4'
gem 'paperclip' #, '2.6.0'
gem 'aws-s3'
gem 'aws-sdk' #, '~> 1.3.4'
gem 'activemerchant' #, "~> 1.20.3"
gem "devise" #, "2.0.5"
gem 'cancan'
gem 'friendly_id' #, "4.0.8"
gem 'nokogiri'
gem 'geokit-rails3', :git => 'git://github.com/leonardoborges/geokit-rails3.git'
gem 'app_constants'
gem 'acts_as_commentable_with_threading', :git => 'git://github.com/elight/acts_as_commentable_with_threading.git'
#gem 'escape_utils' # Has to do with this http://stackoverflow.com/questions/3622394/ruby-1-9-2-strange-warning-when-running-cucumber-specs
gem "gritter" #, "1.0.1"
gem 'sunspot_rails' #, '~> 1.3.0'
gem "dynamic_attributes" #, "~> 1.2.0"
gem "pdfkit"
gem "puma"
gem "jquery-rails" #, "~> 2.0.2"
gem 'enumerated_attribute' #, :require=>false
gem 'seed-fu' #, '~> 2.2.0'
gem 'activerecord-import'
gem 'newrelic_rpm' #, '3.5.3.25'
gem 'redcarpet'
gem 'activemodel-warnings'
gem 'money'
gem 'google_currency'
gem 'profanalyzer', :git => 'git://github.com/purposecampaigns/profanalyzer.git'
gem 'tinymce-rails', '~>3.5'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'compass-rails' #, '~> 1.0.1'
gem 'compass-960-plugin'
gem 'sass-rails' #, "~> 3.2.4"
gem 'deep_cloneable'
gem 'purpose_country_select', '~> 0.0.5', :git => "https://github.com/PurposeOpen/country_select"
gem 'clockwork'
gem 'foreigner'
gem 'roo'
gem 'recurly'
gem 'font-awesome-rails'
gem 'resque'
gem 'resque-retry'
gem 'resque-scheduler'
gem 'resque-loner'
gem 'librato-rails'

group :assets do
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'therubyracer'
  # gem 'debugger', '>= 1.4.0'
  # gem 'bullet'
  gem 'better_errors'
  gem 'binding_of_caller'
  #gem 'pry-stack_explorer'
  gem 'annotate'
end

#exceptionhandling
gem 'honeybadger'
gem 'resque-honeybadger'

group :production, :staging do
  gem 'dalli'
  gem 'kgio'
  gem 'redis-rails'
end

group :development, :staging do
  gem 'oink'
end

group :development, :test do
  gem "rails_best_practices" #, "~> 1.7.2"
  gem 'jslint_on_rails'
  gem 'rspec-rails' #, :require => false #, '~> 2.8.1'
  gem 'guard-rspec' #, '~> 0.7.0'
  gem 'selenium-webdriver' #, "~> 2.27.2"
  gem 'capybara'#, '1.1.2'
  gem 'database_cleaner' #, "~> 0.7.1"
  gem 'cucumber-rails', :require => false #'1.2.0',
  gem 'cucumber'#, '1.1.2'
  gem 'launchy'
  gem 'factory_girl_rails', "~> 4.2.0"
  gem 'email_spec'
  gem 'jasmine' #, '~> 1.1.2'
  gem 'rack-test'
  gem 'sunspot_solr'
  gem "sunspot_matchers" #, "~> 1.3.0.1"
  gem "sunspot_test" #, "~> 0.4.0"
  gem "wkhtmltopdf" #, "~> 0.1.2"
  gem "foreman"
  gem "rspec_junit_formatter"
  gem 'simplecov', :require => false
  gem 'rspec-instafail'
  gem 'rspec-html-matchers' #, '~> 0.2.3'
  gem 'parallel_tests'
  gem 'spork-rails'
  gem 'shoulda-matchers'
  gem 'quiet_assets'
  gem 'subcontractor'
  gem 'fakeweb', :require => false
end
