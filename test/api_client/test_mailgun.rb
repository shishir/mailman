require_relative("../test_helper")
class TestSendgrid < Minitest::Test
  include Rack::Test::Methods
  include Helper

  def test_should_convert_to_api_format_required_by_mailgun
    payload = {"to":["shishir.das@gmail.com"], "cc":["shishir.das@gmail.com"], "bcc":["shishir.das@gmail.com"],"from":"oogabooga@gmail.com", "content":"hi! there"}.to_json
    email = Email.create(mail: payload)
    actual = Api::Mailgun.new.to_hsh(email.mail)
    expected = {:from=>"oogabooga@gmail.com", :to=>"shishir.das@gmail.com", :cc=>"shishir.das@gmail.com", :bcc=>"shishir.das@gmail.com", :subject=>nil, :text=>"hi! there"}

    assert_equal expected, actual
  end
end

