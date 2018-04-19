class EmailsController
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def create
    log("Create called with following params #{params}")
    email = Email.new(mail: params[:mail], status: Email::SENDING)
    if email.save
      [201, {"Content-Type" => "application/json", "location" => "/mail/#{email.id}"}, [{mail: {id: email.id, links: [status: "/mail/#{email.id}/status", self: "/mail/#{email.id}"]}}.to_json]]
    else
      [400, {"Content-Type" => "application/json"}, [{mail: {errors: email.errors}}.to_json] ]
    end
  end

  def status
    email = Email.find(params[:id])
    [200, {"Content-Type" => "application/json"}, [{mail: {id: email.id, status: email.status,  links: [self: "/mail/#{email.id}/status", show: "/mail/#{email.id}"]}}.to_json]]
  end

  def sent
    log("sent")
    update_status(Email::SENT)
  end

  def failed
    log("failed")
    update_status(Email::FAILED)
  end

  private
  def update_status(status)
    log("update #{status} for email with id: #{params[:id]}")
    email = Email.find(params[:id])
    email.status = status
    if email.save
      [200, {"Content-Type" => "application/json"}, [{mail: {id: email.id, links: [status: "/mail/#{email.id}/status", self: "/mail/#{email.id}"]}}.to_json]]
    else
      [422, {"Content-Type" => "application/json"}, [{mail: {id: email.id, errors: email.errors, links: [status: "/mail/#{email.id}/status", self: "/mail/#{email.id}"]}}.to_json]]
    end
  end
end