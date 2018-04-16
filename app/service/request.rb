class Request
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def send_path?
    request.path_info =~ /send/
  end

  def status_path?
    request.path_info =~ /mail\/([1-9]*)\/status/
  end


  def process
    if send_path?
      email = Email.new(mail: request.body.read, status: Email::SENDING)
      if email.save
        [201, {"Content-Type" => "application/json", "location" => "/mail/#{email.id}"}, [{id: email.id, links: [status: "/mail/#{email.id}/status", self: "/mail/#{email.id}"]}.to_json]]
      else
        [400, {"Content-Type" => "application/json"}, [{mail: {errors: email.errors}}.to_json] ]
      end
    elsif status_path?
      if match_data = /mail\/([1-9]*)\/status/.match(request.path_info)
        email = Email.find(match_data[1])
        [200, {"Content-Type" => "application/json"}, [{id: email.id, status: email.status,  links: [self: "/mail/#{email.id}/status", show: "/mail/#{email.id}"]}.to_json]]
     end
    end
  end
end