require 'minitest/autorun'
require 'rack/test'

ENV['MAILMAN_ENV'] = "test"
require_relative('../mailman_web.rb')

module Helper
  def valid_payload
    '{"to":["shishir.das@gmail.com"], "from":"oogabooga@gmail.com", "content":"hi! there"}'
  end

  def invalid_payload
    '{}'
  end
end
