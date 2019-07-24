require 'yaml'

module Leter
  class AccountConfig
    DEFAULT_CONFIG = File.expand_path('default_config.yml', __dir__)

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

    def date_format
      @config[:date_format]
    end

    def date_format=(format)
      @config[:date_format] = format
    end

    def to_yaml
      @config.to_yaml
    end

    def self.filename
      'leter.yml'
    end

    def self.load(filename)
      config_yaml = YAML.load(
        ERB.new(
          File.read(filename)
        ).result
      )

      new(config_yaml)
    end

    def self.default
      load(DEFAULT_CONFIG)
    end
  end
end
