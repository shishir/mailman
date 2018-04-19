module Mailman
  module Consumer
    class Mailgun
      include Phobos::Handler
      include Phobos::Producer

      def consume(payload, metadata)
        hsh = JSON.parse(payload)
        email = JSON.parse(payload)["mail"]
        Api::Mailgun.new.send(hsh["mail"])
      rescue Exception => e
        self.producer.publish(MailmanConfig.status, payload, MailmanConfig.partition)
      end
    end
  end
end