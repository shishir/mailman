require_relative("../test_helper")
class TestRequest < Minitest::Test
  include Rack::Test::Methods
  include Helper

  def setup
    Email.delete_all
  end

  def app
    Rack::Builder.parse_file("config.ru").first
  end

  def test_process_does_not_save_email_to_database
    post("/send", invalid_payload,  {'CONTENT_TYPE' => 'application/json'} )
    assert_equal 400, last_response.status
    assert_equal +"{\"mail\":{\"errors\":{\"to\":[\"field is required\"],\"from\":[\"field is required\"],\"content\":[\"field is required\"]}}}", last_response.body
    assert_equal 0, Email.count
  end

  def test_post_send
    post("/send", valid_payload,  {'CONTENT_TYPE' => 'application/json'} )
    assert_equal 1, Email.count
    id = Email.last.id
    assert_equal 201, last_response.status
    assert_equal Email::SENDING, Email.last.status
    assert_equal "/mail/#{id}", last_response.location
    assert_equal "{\"id\":#{id},\"links\":[{\"status\":\"/mail/#{Email.last.id}/status\",\"self\":\"/mail/#{id}\"}]}", last_response.body
  end

  def test_get_email
    email = Email.create(mail: valid_payload, status: Email::SENDING)
    get "/mail/#{email.id}/status"
    assert_equal 200, last_response.status
    assert_equal "sending", JSON.parse(last_response.body)["status"]
  end
end

