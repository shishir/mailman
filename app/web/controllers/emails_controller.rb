class EmailsController
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def create
    email = Email.new(mail: params[:mail], status: Email::SENDING)
    if email.save
      [201, {"Content-Type" => "application/json", "location" => "/mail/#{email.id}"}, [{id: email.id, links: [status: "/mail/#{email.id}/status", self: "/mail/#{email.id}"]}.to_json]]
    else
      [400, {"Content-Type" => "application/json"}, [{mail: {errors: email.errors}}.to_json] ]
    end
  end

  def status
    email = Email.find(params[:id])
    [200, {"Content-Type" => "application/json"}, [{id: email.id, status: email.status,  links: [self: "/mail/#{email.id}/status", show: "/mail/#{email.id}"]}.to_json]]
  end

  def update
    # match_data = /mail\/([1-9]*)\/status/.match(request.path_info)
    # email = Email.find(match_data[1])
    # [200, {"Content-Type" => "application/json"}, [{id: email.id, status: email.status,  links: [self: "/mail/#{email.id}/status", show: "/mail/#{email.id}"]}.to_json]]
  end
end