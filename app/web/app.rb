# Main entry point. Use rack-contrib to use routing/caching middlewares or
# move to sinatra which is significantly slower but have better rest api support.
require 'json'

class App
  def call(env)
    @request = Rack::Request.new(env)
    if create?
      return EmailsController.new(params).create
    elsif status?
      return EmailsController.new(params).status
    elsif sent?
      return EmailsController.new(params).sent
    elsif failed?
      return EmailsController.new(params).failed
    end
  end

  private
  def create?
    @request.path_info =~ /send/ && @request.post?
  end

  def status?
    # TODO: Cache request based on Etag
    @request.path_info =~ /mail\/[1-9]*\/status/ && @request.get?
  end

  def sent?
    @request.path_info =~ /mail\/[1-9]*\/sent/ && @request.post?
  end

  def failed?
    @request.path_info =~ /mail\/[1-9]*\/failed/ && @request.post?
  end

  def params
    hsh = {}
    if create?
      hsh[:mail] = @request.body.read
    end
    if status? || sent? || failed?
      match_data = /mail\/([1-9]*)/.match(@request.path_info)
      hsh[:id] = match_data[1]
    end
    hsh
  end

end