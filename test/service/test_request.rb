require_relative("../test_helper")
class TestRequest < Minitest::Test
  include Rack::Test::Methods

  def setup
    Email.delete_all
  end

  def app
    Rack::Builder.parse_file("config.ru").first
  end

  def test_process_does_not_save_email_to_database
    post("/send", invalid_payload,  {'CONTENT_TYPE' => 'application/json'} )
    assert_equal 400, last_response.status
    assert_equal 0, Email.count
  end

  def test_post_send
    post("/send", valid_payload,  {'CONTENT_TYPE' => 'application/json'} )
    assert_equal 1, Email.count
    assert_equal "mail/#{Email.last.id}", last_response.location
  end

  private
  def valid_payload
    '{"to":["shishir.das@gmail.com"], "from":"oogabooga@gmail.com", "content":"hi! there"}'
  end

  def invalid_payload
    '{}'
  end
end

