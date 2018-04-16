require 'rack'
require 'yaml'
require 'active_record'
require 'json'


require_relative("app/service/email.rb")
require_relative("app/service/request.rb")
require_relative("app/service/request_controller.rb")

ENV['MAILMAN_ENV'] ||= "development"
ActiveRecord::Base.configurations = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection ENV['MAILMAN_ENV'].to_sym


