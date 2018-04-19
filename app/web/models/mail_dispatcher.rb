class MailDispatcher
  include Phobos::Producer
  class << self
    Phobos.configure('config/phobos.yml')
    def publish(email)
      payload = {id: email.id, mail: email.mail}.to_json
      self.producer.async_publish(MailmanConfig.main_topic, payload, "#{MailmanConfig.main_topic}-partition")
    end
  end
end