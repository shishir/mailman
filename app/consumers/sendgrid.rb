class Sendgrid
  include Phobos::Handler
  include Phobos::Producer
  def consume(payload, metadata)
    if [true,false].sample
      p "Sengrid consumed #{payload} #{metadata}"
    else
      self.producer.publish('backup-mailer', payload, 'mail')
    end
  end
end