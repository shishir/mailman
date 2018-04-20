require_relative("../test_helper")
class TestSendgrid < Minitest::Test
  include Rack::Test::Methods
  include Helper

  def test_should_convert_to_api_format_required_by_sendgrid
    email = Email.create(mail: valid_payload)
    actual = Api::Sendgrid.new.to_json(email.mail)
    expected = {
     "personalizations": [
      {
        "to": [
          {
            "email": "shishir.das@gmail.com",
          }
          ],
          "subject": "Hello, World!"
      }],
      "from": {
        "email": "oogabooga@gmail.com",
        },
      "content": [{
        "type": "text/plain",
        "value": "hi! there"
      }]
    }.to_json()

    assert_equal expected, actual
  end

  def test_should_convert_to_api_format_with_cc_bcc_required_by_sendgrid
    payload = {"to":["shishir.das@gmail.com"], "cc":["shishir.das@gmail.com"], "bcc":["shishir.das@gmail.com"],"from":"oogabooga@gmail.com", "content":"hi! there"}.to_json
    email = Email.create(mail: payload)
    actual = Api::Sendgrid.new.to_json(email.mail)
    expected = {
     "personalizations": [
      {
        "to": [
          {
            "email": "shishir.das@gmail.com",
          }],
        "subject": "Hello, World!",
        "cc": [
          {
            "email": "shishir.das@gmail.com",
          }],
        "bcc": [
          {
            "email": "shishir.das@gmail.com",
          }]
      }],
      "from": {
        "email": "oogabooga@gmail.com",
        },
      "content": [{
        "type": "text/plain",
        "value": "hi! there"
      }]
    }.to_json()

    assert_equal expected, actual
  end

end

