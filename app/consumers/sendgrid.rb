class Sendgrid
  include Phobos::Handler
  include Phobos::Producer
  def consume(payload, metadata)
    begin
      email = JSON.parse(payload)["mail"]
      Api::Sendgrid.new.send(email)
      self.producer.publish(MailmanConfig.status, payload, MailmanConfig.partition)
    rescue Exception => e
      self.producer.publish(MailmanConfig.backup_topic, payload, MailmanConfig.partition)
    end
  end
end