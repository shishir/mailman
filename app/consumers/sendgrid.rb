class Sendgrid
  include Phobos::Handler
  include Phobos::Producer
  def consume(payload, metadata)
    if [true,false].sample
      p "Sengrid consumed #{payload} #{metadata}"
    else
      self.producer.publish(MailmanConfig.backup_mailer, payload, MailmanConfig.mailer)
    end
  end
end