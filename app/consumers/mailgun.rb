# Kafka Consumer for Mailgun
module Mailman
  module Consumer
    class Mailgun
      include Phobos::Handler
      include Phobos::Producer

      def consume(payload, metadata)
        hsh = JSON.parse(payload)
        @circuit_breaker ||= CircuitBreaker.new {Api::Mailgun.new.send(hsh["mail"])}
        @circuit_breaker.call

        hsh[:status] = "success"
        self.producer.async_publish(MailmanConfig.status_topic, hsh.to_json, "#{MailmanConfig.status_topic}-partition}")
      rescue CircuitBreakerOpen => e
        hsh[:status] = "failure"
        self.producer.async_publish(MailmanConfig.status_topic, hsh.to_json, "#{MailmanConfig.status_topic}-partition}")
      rescue Exception
        # Handle all other exception here. Mark the message failure.
        # TODO, handle api exception seperate to provide more information to the user.
        hsh[:status] = "failure"
        self.producer.async_publish(MailmanConfig.status_topic, hsh.to_json, "#{MailmanConfig.status_topic}-partition}")
      end
    end
  end
end