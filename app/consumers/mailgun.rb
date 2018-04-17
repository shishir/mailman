class Mailgun
  include Phobos::Handler
  include Phobos::Producer

  def consume(payload, metadata)
    email = JSON.parse(payload)["mail"]
    Api::Mailgun.new.send(email)
  rescue Exception => e
    self.producer.publish(MailmanConfig.status, payload, MailmanConfig.partition)
  end
end
