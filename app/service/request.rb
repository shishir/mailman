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
      data = request.body.read
      email = Email.create(mail: data)
      # publish
    else
      # send not_found
    end
  end
end