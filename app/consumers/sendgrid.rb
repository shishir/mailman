module Mailman
  module Consumer
    class Sendgrid
      include Phobos::Handler
      include Phobos::Producer
      def consume(payload, metadata)
        begin
          hsh = JSON.parse(payload)
          circuitBreaker = CircuitBreaker.new {Api::Sendgrid.new.send(hsh["mail"])}.call
          hsh[:status] = "success"
          self.producer.publish(MailmanConfig.status_topic, hsh.to_json, MailmanConfig.partition)
        rescue CircuitBreakerOpen
          hsh[:status] = "failure"
          self.producer.publish(MailmanConfig.backup_topic, hsh.to_json, MailmanConfig.partition)
        end
      end
    end
  end
end