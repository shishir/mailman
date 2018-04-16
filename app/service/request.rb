class Request
  attr_reader :request

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def send_email?
    request.path_info =~ /send/
  end

  def process
    data = request.body.read
    if send_email?

      # save to db
      # publish
    else
      # send not_found
    end
  end
end