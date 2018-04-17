require 'rack'
require 'yaml'
require 'active_record'
require 'json'


require_relative("app/web/models/email.rb")
require_relative("app/web/controllers/request.rb")
require_relative("app/web/app.rb")

ENV['MAILMAN_ENV'] ||= "development"
ActiveRecord::Base.configurations = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection ENV['MAILMAN_ENV'].to_sym


