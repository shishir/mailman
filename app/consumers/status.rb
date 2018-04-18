class Mailgun
  include Phobos::Handler

  def consume(payload, metadata)
    email = JSON.parse(payload)["id"]

  rescue Exception => e
    self.producer.publish(MailmanConfig.status, payload, MailmanConfig.partition)
  end
end
