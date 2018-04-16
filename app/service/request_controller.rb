require 'json'

class RequestController
  def call(env)
    req = Request.new(Rack::Request.new(env))
    data = req.process
    return data
  end
end