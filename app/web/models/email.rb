class Email < ActiveRecord::Base

    SENDING = "sending"
    SENT    = "sent"
    FAILED  = "failed"


  validate :correctness_of_to_field
  validate :correctness_of_from_field
  validate :presence_of_content
  validate :email_format_for_cc_bcc_list

  after_save :publish

  def correctness_of_to_field
    to = content_hash["to"]
    errors.add(:to, "field is required")  if to.nil?
    errors.add(:to, "field should not be empty. expects a list of email address")  if to&.empty?
    validate_email_format(:to, to) if to
  end

  def correctness_of_from_field
    from = content_hash["from"]
    errors.add(:from, "field is required")  if !from|| from&.blank?
    validate_email_format(:from, [from]) if from
  end

  def email_format_for_cc_bcc_list
    # revist this one.
    if cc = content_hash["cc"]
      validate_email_format(:cc, cc)
    end
    if bcc = content_hash["bcc"]
      validate_email_format(:bcc, bcc)
    end
  end

  def presence_of_content
    content = content_hash["content"]
    errors.add(:content, "field is required")  if !content|| content&.blank?
  end

  def publish
    MailDispatcher.publish(self)
  end

  private
  def content_hash
    @content_hash ||= JSON.parse(self.mail)
  end

  def validate_email_format(field_name, emails)
      invalid_emails = emails.inject([]) do |invalid_emails, email|
        unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
          invalid_emails << email
        end
        invalid_emails
      end
      if invalid_emails.length > 0
        errors.add(field_name, "following email address are incorred #{invalid_emails.join(',')}")
      end
  end
end