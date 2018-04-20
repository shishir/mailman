# Kafka Consumer for Sendgrid.
# TODO: partition should be parameterized.
module Mailman
  module Consumer
    class Sendgrid
      include Phobos::Handler
      include Phobos::Producer
      def consume(payload, metadata)
        begin
          hsh = JSON.parse(payload)
          log(hsh)
          CircuitBreaker.new {Api::Sendgrid.new.send(hsh["mail"])}.call
          hsh[:status] = "success"
          self.producer.async_publish(MailmanConfig.status_topic, hsh.to_json, "#{MailmanConfig.status_topic}-partition}")
        rescue CircuitBreakerOpen
          hsh[:status] = "failure"
          self.producer.async_publish(MailmanConfig.backup_topic, hsh.to_json, "#{MailmanConfig.backup_topic}-partition}")
        rescue Exception
          # Handle all other exception here. Mark the message failure.
          hsh[:status] = "failure"
          self.producer.async_publish(MailmanConfig.status_topic, hsh.to_json, "#{MailmanConfig.status_topic}-partition}")
        end
      end
    end
  end
end