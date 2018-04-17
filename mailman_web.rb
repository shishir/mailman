require 'rack'
require 'yaml'
require 'active_record'
require 'json'
require 'kafka'
require 'phobos'
require 'net/http'

require_relative("app/web/models/email.rb")
require_relative("app/mailman_config.rb")
require_relative("app/web/models/mail_dispatcher.rb")
require_relative("app/web/controllers/request.rb")
require_relative("app/web/app.rb")


ENV['MAILMAN_ENV'] ||= "development"
ActiveRecord::Base.configurations = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection ENV['MAILMAN_ENV'].to_sym

module MailmanWeb
  def self.root
    File.dirname __FILE__
  end
end


