require_relative("../test_helper")
class TestEmail < Minitest::Test

  def test_validate_to_field
    field_not_pased = Email.new(mail: "{}")


    empty_list_passed = Email.new(mail: '{"to": []}')
    assert_equal false , empty_list_passed.valid?
    assert_equal 1     , empty_list_passed.errors[:to].length

    (valid_list = Email.new(mail: {to: ["shishir.das@gmail.com"]}.to_json)).valid?
    assert_equal 0, valid_list.errors[:to].length

   (incorrect_email = Email.new(mail: {to: ["blah"]}.to_json)).valid?
    assert_equal 1, incorrect_email.errors[:to].length

  end

  def test_to_allows_multiple_values
    (email = Email.new(mail: {to: ["shishir.das@gmail.com", "foo@bar.com", "mia@kia.com"]}.to_json)).valid?
    assert_equal 0, email.errors[:to].length
  end

  def test_validate_from_field
    from_not_passed = Email.new(mail: "{}")
    assert_equal false, from_not_passed.valid?
    assert_equal 1, from_not_passed.errors[:from].length

    (from_passed = Email.new(mail: {from: "shishir.das@gmail.com"}.to_json)).valid?
    assert_equal 0, from_passed.errors[:from].length

    (from_passed = Email.new(mail: {from: "blah"}.to_json)).valid?
    assert_equal 1, from_passed.errors[:from].length
  end

  def test_validate_cc_field
    cc_not_passed = Email.new(mail: "{}")
    assert_equal false, cc_not_passed.valid?
    assert_equal 0, cc_not_passed.errors[:cc].length

    empty_cc_list = Email.new(mail: '{"cc": []}')
    assert_equal false, empty_cc_list.valid?
    assert_equal 0, empty_cc_list.errors[:cc].length

    cc_with_malformed_email_address  = Email.new(mail: '{"cc": ["blah"]}')
    assert_equal false, cc_with_malformed_email_address.valid?
    assert_equal 1, cc_with_malformed_email_address.errors[:cc].length
  end

  def test_validate_bcc_field
    bcc_not_passed = Email.new(mail: "{}")
    assert_equal false, bcc_not_passed.valid?
    assert_equal 0, bcc_not_passed.errors[:bcc].length

    empty_bcc_list = Email.new(mail: '{"bcc": []}')
    assert_equal false, empty_bcc_list.valid?
    assert_equal 0, empty_bcc_list.errors[:bcc].length

    bcc_with_malformed_email_address  = Email.new(mail: '{"bcc": ["blah"]}')
    assert_equal false, bcc_with_malformed_email_address.valid?
    assert_equal 1, bcc_with_malformed_email_address.errors[:bcc].length
  end

  def test_validate_content_field
    no_content = Email.new(mail: "{}")
    assert_equal false , no_content.valid?
    assert_equal 1     , no_content.errors[:content].length
  end
end
