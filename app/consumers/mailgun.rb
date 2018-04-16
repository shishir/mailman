class Mailgun
  include Phobos::Handler

  def consume(payload, metadata)
    p "Mailgun consumed #{payload}, #{metadata}"
  end
end
