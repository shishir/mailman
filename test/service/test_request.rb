  require_relative("../test_helper")
  class TestRequest < Minitest::Test

  def setup
    Email.delete_all
  end

  def test_send_email_matches_correct_route
    mock_rack_request = Minitest::Mock.new
    mock_rack_request.expect :path_info, "/send"

    request = Request.new(mock_rack_request)
    assert request.send_email?
    assert_mock mock_rack_request

    mock_rack_request = Minitest::Mock.new
    mock_rack_request.expect :path_info, "/"

    request = Request.new(mock_rack_request)
    assert !request.send_email?
    assert_mock mock_rack_request
  end

  def test_process_saves_email_to_database

    mock_rack_request()
    mock_email = Minitest::Mock.new
    request = Request.new(mock_rack_request)
    request.process

    assert_equal 1, Email.count
  end

  def mock_rack_request
    req = Minitest::Mock.new
    req.expect :path_info, "/send"
    json_payload = '{"to":["shishir.das@gmail.com"], "from":"oogabooga@gmail.com", "content":"hi! there"}'
    req.expect :body, Minitest::Mock.new.expect(:read, json_payload)
    req
  end
end

