class Mailgun
  include Phobos::Handler

  def consume(payload, metadata)
    email = JSON.parse(payload)["mail"]
    Api::Mailgun.new.send(email)
  rescue Exception => e
    p "foo"
  end
end
