class Request
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def send_email?
    request.path_info =~ /send/
  end

  def process
    if send_email?
      email = Email.new(mail: request.body.read)
      if email.save
        [200, {"Content-Type" => "application/json", "location" => "mail/#{email.id}"}, []]
      else
        [400, {"Content-Type" => "application/json"}, [{mail: {errors: email.errors}}] ]
      end
    else
      # send not_found
    end
  end
end