# frozen_string_literal: true

require 'yaml'

require 'leter/theme'

module Leter
  class AccountConfig
    attr_writer :theme, :google_analytics, :date_format, :css_file_path, :code_theme, :code_font

    DEFAULT_CONFIG = File.expand_path('default_config.yml', __dir__)

    # TODO: load hack
    CODE_FONT = 'Hack'
    # TODO: document all the theme options
    CODE_THEME = 'Atom'

    def initialize(config = {})
      @config = config.transform_keys(&:to_sym)
    end

    def theme
      style = @theme || @config[:theme]

      return unless style

      style = { name: style } if style.is_a?(String)

      Leter::Theme.new(style.delete(:name) || Theme::DEFAULT).tap do |t|
        style.each do |key, value|
          t.set_attribute(key.to_s, value)
        end
      end
    end

    def google_analytics
      @google_analytics || @config[:google_analytics]
    end

    def date_format
      @date_format || @config[:date_format]
    end

    # hidden path to edit css locally
    def css_file_path
      @css_file_path || @config[:css_file_path]
    end

    # TODO: atom for default
    def code_theme
      @code_theme || code[:theme] || CODE_THEME
    end

    # TODO: test hack font
    def code_font
      @code_font || code[:font] || CODE_FONT
    end

    def to_yaml
      @config.to_yaml
    end

    def self.filename
      'leter.yml'
    end

    def self.load(filename)
      config_yaml = YAML.safe_load(
        ERB.new(
          File.read(filename)
        ).result,
        [Symbol]
      )

      new(config_yaml)
    rescue Errno::ENOENT
      raise Leter::NoConfigError
    end

    def self.default
      load(DEFAULT_CONFIG)
    end

    private

    def code
      @config[:code] || {}
    end
  end
end
