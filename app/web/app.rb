require 'json'

class App
  def call(env)
    EmailsController.new(Rack::Request.new(env)).process
  end
end