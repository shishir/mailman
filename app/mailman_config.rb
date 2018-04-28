#Load application config
# Use settingslogic to dynamically load config. Add additional configuration
# related to sendgrid/mailman api in the config.
class MailmanConfig
  class << self
    def settings
      @settings ||= YAML.load(File.open("#{Mailman.root}/config/mailman.yml"))
    end

    def main_topic
      ENV['BROKER_MAIN_TOPIC'] #|| settings["broker"]["main_topic"]
    end

    def backup_topic
      ENV['BROKER_BACKUP_TOPIC'] #|| settings["broker"]["backup_topic"]
    end

    def status_topic
      ENV['BROKER_STATUS_TOPIC'] #|| settings["broker"]["status_topic"]
    end

    def web_success_url
      ENV['WEB_SUCCESS_URL'] #|| settings["web"]["success"]
    end

    def web_failure_url
      ENV['WEB_FAILURE_URL'] #|| settings["web"]["failed"]
    end
  end
end
