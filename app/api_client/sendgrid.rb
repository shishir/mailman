# Sendgrid API client.
# TODO: Exception handing other than timeout.
#       Move configurations to yaml.
#       Implement sending CC/BCC fields

require_relative('./http_client.rb')
module Api
  class Sendgrid
    def initialize
      @api_key     = ENV['SENGRID_API_KEY']
      @base_url    = "https://sendgrid.com/v3"
      @http_client = HttpClient.new
    end

    def send(content)
      data = to_json(content)
      headers = {"Authorization" => "Bearer #{@api_key}", "Content-Type" => "application/json"}
      @http_client.post("#{@base_url}/mail/send", headers, data)
    end

    def send_url
      "#{@base_url}/mail/send"
    end
    def to_json(data)
      to_hash(data).to_json
    end
    def to_hash(data)
      xml_data = JSON.parse(data)

      data = {
       personalizations: [
        {
          to: fields(xml_data["to"]),
          subject: "Hello, World!"
         }],
        from: {
          email: xml_data["from"]
        },
        content: [{
          type: "text/plain",
          value: xml_data["content"]
        }]
      }

      data[:personalizations][0][:cc] = fields(xml_data["cc"]) unless xml_data["cc"].nil? || xml_data["cc"].empty?
      data[:personalizations][0][:bcc] = fields(xml_data["bcc"]) unless xml_data["bcc"].nil? || xml_data["bcc"].empty?
      data
    end

    private
    def fields(data)
      (data || []).inject([]) do |l, email|
        l << {email: email}
      end || []
    end
  end
end