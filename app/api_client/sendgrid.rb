require_relative('./http_client.rb')
class Sendgrid
  def initialize
    @api_key = ENV['SENGRID_API_KEY']
    @base_url = "https://sendgrid.com/v3"
    @http_client = HttpClient.new
  end

  def send(email)
    data = to_json(email.mail)
    headers = {"Authorization" => "Bearer #{@api_key}", "Content-Type" => "application/json"}
    @http_client.post("#{@base_url}/mail/send", headers, data)
  end

  def send_url
    "#{@base_url}/mail/send"
  end
  def to_json(data)
    xml_data = JSON.parse(data)

    data = {
     personalizations: [
      {
        to: fields(xml_data["to"]),
        # cc: fields(xml_data["cc"]),
        # bcc: fields(xml_data["bcc"]),
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
  end

  private
  def fields(data)
    (data || []).inject([]) do |l, email|
      l << {email: email}
    end || []
  end
end