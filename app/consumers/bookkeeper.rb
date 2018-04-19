module Mailman::Consumers
  class Bookkeeper
    include Phobos::Handler

    def consume(payload, metadata)
      payload = JSON.parse(payload)
      http_client = HttpClient.new
      begin
        url = payload["status"] == "success" ? MailmanConfig.web_success_url
              : MailmanConfig.web_failure_url
        url.gsub(/:id/, payload[:id])
        http_client.post(url, "{}")
      rescue Exception => e
        # Log exception
        # Raise alert
      end
    end
  end
end