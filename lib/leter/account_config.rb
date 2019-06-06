require 'yaml'

module Leter
  class AccountConfig
    DEFAULT_CONFIG = YAML.load_file("#{Dir.pwd}/lib/leter/default_config.yml")

    def initialize(config = {})
      @config = config.transform_keys(&:to_sym)
    end

    def theme
      @config[:theme] || 'default'
    end

    def theme=(theme)
      @config[:theme] = theme
    end

    def google_analytics
      @config[:google_analytics]
    end

    def google_analytics=(id)
      @config[:google_analytics] = id
    end

    #TODO date format for blog posts
    def date_format
      @config[:date_format]
    end

    def date_format=(format)
      @config[:date_format] = format
    end

    def pro?
      @pro || false
    end

    # pro is internal only
    # users can't change it
    def pro=(pro)
      @pro = pro
    end

    def to_yaml
      @config.to_yaml
    end

    def self.filename
      'leter.yml'
    end

    def self.default
      new(DEFAULT_CONFIG)
    end
  end
end
