require 'json'

class RequestController
  def call(env)
    req = Request.new(env)
    req.process
    [200, {"Content-Type" => "application/json"}, []]
  end
end