# Use this file to load your code
puts <<~ART
  ______ _           _
  | ___ \\ |         | |
  | |_/ / |__   ___ | |__   ___  ___
  |  __/| '_ \\ / _ \\| '_ \\ / _ \\/ __|
  | |   | | | | (_) | |_) | (_) \\__ \\
  \\_|   |_| |_|\\___/|_.__/ \\___/|___/
ART
puts "
phobos_boot.rb - find this file at #{File.expand_path(__FILE__)}

"
require 'net/http'
require_relative 'app/api_client/http_client.rb'
require_relative 'app/api_client/sendgrid.rb'
require_relative 'app/api_client/mailman.rb'
require_relative 'app/mailman_config.rb'
require_relative 'app/consumers/sendgrid.rb'
require_relative 'app/consumers/mailgun.rb'
