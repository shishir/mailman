require 'json'

class App
  def call(env)
    Request.new(Rack::Request.new(env)).process
  end
end