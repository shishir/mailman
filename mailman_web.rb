require 'rack'
require 'yaml'
require 'active_record'
require 'json'
require 'kafka'
require 'phobos'
require 'net/http'
require 'logger'

require_relative("app/web/models/email.rb")
require_relative("app/mailman_config.rb")
require_relative("app/web/models/mail_dispatcher.rb")
require_relative("app/web/controllers/emails_controller.rb")
require_relative("app/web/app.rb")


ENV['MAILMAN_ENV'] ||= "development"
# ActiveRecord::Base.configurations = YAML.load(File.read('config/database.yml'))
db_connection_params =  {  
  adapter: ENV['MAILMAN_DB_ADAPTER'],
  encoding: 'utf8',
  reconnect: false,
  database: ENV['MAILMAN_DB_DATABASE'],
  pool: ENV['MAILMAN_DB_POOL'],
  username: ENV['MAILMAN_DB_USERNAME'],
  password: ENV['MAILMAN_DB_PASSWORD'],
  host: ENV['MAILMAN_DB_HOST'],
}
puts db_connection_params
# config = YAML.load(File.read('config/database.yml'))
# ActiveRecord::Base.establish_connection config[ENV['MAILMAN_ENV']]
ActiveRecord::Base.establish_connection db_connection_params


module Mailman
  def self.root
    File.dirname __FILE__
  end

  def log(msg)
    @logger ||= Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @logger.info(msg)
  end
end
include Mailman


