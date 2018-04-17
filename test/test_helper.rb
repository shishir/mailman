require 'minitest/autorun'
require 'rack/test'

ENV['MAILMAN_ENV'] = "test"
require_relative "../mailman_web.rb"

require_relative "#{Mailman.root}/app/api_client/http_client.rb"
require_relative "#{Mailman.root}/app/api_client/sendgrid.rb"
require_relative "#{Mailman.root}/app/api_client/mailgun.rb"
require_relative "#{Mailman.root}/app/mailman_config.rb"

module Helper
  def valid_payload
    '{"to":["shishir.das@gmail.com"],"from":"oogabooga@gmail.com", "content":"hi! there"}'
  end

  def invalid_payload
    '{}'
  end

  def stub_mail_dispatcher
    mock = Minitest::Mock.new
    MailDispatcher.stub :publish, mock do;end
  end
end
