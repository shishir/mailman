class Sendgrid
  include Phobos::Handler
  include Phobos::Producer
  def consume(payload, metadata)
    begin
      email = JSON.parse(payload)["mail"]
      Api::Sendgrid.new.send(email)
    rescue Exception => e
      self.producer.publish(MailmanConfig.backup_topic, payload, MailmanConfig.partition)
    end
  end
end