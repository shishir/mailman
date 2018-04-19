#Load application config
# Use settingslogic to dynamically load config. Add additional configuration
# related to sendgrid/mailman api in the config.
class MailmanConfig
  class << self
    def settings
      @settings ||= YAML.load(File.open("#{Mailman.root}/config/mailman.yml"))
    end

    def main_topic
      settings["broker"]["main_topic"]
    end

    def backup_topic
      settings["broker"]["backup_topic"]
    end

    def status_topic
      settings["broker"]["status_topic"]
    end

    def web_success_url
      settings["web"]["success"]
    end

    def web_failure_url
      settings["web"]["failed"]
    end
  end
end
