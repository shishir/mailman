require 'json'

class App
  def call(env)
    @request = Rack::Request.new(env)
    if create?
      return EmailsController.new(params).create
    elsif status?
      return EmailsController.new(params).status
    elsif update?
      return EmailsController.new(params).update
    end
  end

  private
  def create?
    @request.path_info =~ /send/ && @request.post?
  end

  def status?
    @request.path_info =~ /mail\/[1-9]*\/status/ && @request.get?
  end

  def update?
    false
  end

  def params
    hsh = {}
    if create?
      hsh[:mail] = @request.body.read
    end
    if status?
      match_data = /mail\/([1-9]*)\/status/.match(@request.path_info)
      hsh[:id] = match_data[1]
    end
    hsh
  end

end