require_relative("../test_helper")
class TestSendgrid < Minitest::Test
  include Rack::Test::Methods
  include Helper

  def test_should_convert_to_api_format_required_by_mailgun
    email = Email.create(mail: valid_payload)
    actual = Mailgun.new.to_hsh(email.mail)
    expected = {:from=>"oogabooga@gmail.com", :to=>"shishir.das@gmail.com", :subject=>nil, :text=>"hi! there"}
    Mailgun.new.send(email)
    assert_equal expected, actual
  end
end

