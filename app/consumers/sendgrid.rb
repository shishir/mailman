module Mailman
  module Consumer
    class Sendgrid
      include Phobos::Handler
      include Phobos::Producer
      def consume(payload, metadata)
        begin
          hsh = JSON.parse(payload)
          Api::Sendgrid.new.send(hsh["mail"])
          hsh[:status] = "success"
          self.producer.publish(MailmanConfig.status, hsh.to_json, MailmanConfig.partition)
        rescue Exception => e
          hsh[:status] = "failure"
          self.producer.publish(MailmanConfig.backup_topic, hsh.to_json, MailmanConfig.partition)
        end
      end
    end
  end
end