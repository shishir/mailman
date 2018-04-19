module Mailman
  module Consumer
    class Mailgun
      include Phobos::Handler
      include Phobos::Producer

      def consume(payload, metadata)
        hsh = JSON.parse(payload)
        circuitBreaker = CircuitBreaker.new {Api::Mailgun.new.send(hsh["mail"])}.call
        hsh[:status] = "success"
        self.producer.publish(MailmanConfig.status_topic, hsh.to_json, MailmanConfig.partition)
      rescue CircuitBreakerOpen => e
        hsh[:status] = "failure"
        self.producer.publish(MailmanConfig.status_topic, payload, MailmanConfig.partition)
      end
    end
  end
end