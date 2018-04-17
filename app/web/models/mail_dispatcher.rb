class MailDispatcher
  include Phobos::Producer
  class << self
    Phobos.configure('config/phobos.yml')
    def publish(email)
      payload = {id: email.id, mail: email.mail}
      self.producer.publish(MailmanConfig.main_topic, payload, MailmanConfig.partition)
    end
  end
end