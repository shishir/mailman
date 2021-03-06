# Mailgun API client.
# TODO: Exception handing other than timeout.
require_relative('./http_client.rb')
module Api
  class Mailgun
    def initialize
      @api_key     = ENV['MAILGUN_API_KEY']
      @domain_name = ENV['MAILGUN_DOMAIN_NAME']
      @base_url    = "https://api:#{@api_key}@api.mailgun.net/v3/#{@domain_name}"
      @http_client = HttpClient.new
    end

    def send(mail)
      data = URI.encode_www_form(to_hsh(mail))
      @http_client.post("#{@base_url}/mail/send", {}, data)
    end

    def send_url
      "#{@base_url}/messages"
    end

    def to_hsh(data)
      xml_data = JSON.parse(data)

      data = {}
      data[:from] = xml_data["from"]
      data[:to] = xml_data["to"].join(",")
      data[:cc] = xml_data["cc"].join(",") if xml_data["cc"].present?
      data[:bcc] = xml_data["bcc"].join(",") if xml_data["bcc"].present?
      data[:subject] = xml_data["subject"]
      data[:text] = xml_data["content"]
      data
    end
  end
end