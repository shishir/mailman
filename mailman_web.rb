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
ActiveRecord::Base.configurations = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection ENV['MAILMAN_ENV'].to_sym

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


