# Updates status of email via status api exposed by the email webservice.
# TODO: Exception Handling. Should add circuit breaker here.
module Mailman
  module Consumer
    class Bookkeeper
      include Phobos::Handler

      def consume(payload, metadata)
        begin
          payload = JSON.parse(payload)
          http_client = HttpClient.new
          url = payload["status"] == "success" ? MailmanConfig.web_success_url
                : MailmanConfig.web_failure_url
          url = url.gsub(/:id/, payload["id"].to_s)
          log(url)
          http_client.post(url, {})
        rescue Exception
        end
      end
    end
  end
end