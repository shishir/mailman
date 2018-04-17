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

    def partition
      settings["broker"]["partition"]
    end
  end
end
