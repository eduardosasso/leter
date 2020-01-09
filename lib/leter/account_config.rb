# frozen_string_literal: true

require 'yaml'

require 'leter/theme'
require 'active_support/core_ext/hash/indifferent_access'

module Leter
  class AccountConfig
    attr_writer :theme, :google_analytics, :date_format, :css_url, :code_theme, :code_font
    attr_writer :title, :description
    attr_reader :config

    DEFAULT_CONFIG = File.expand_path('default_config.yml', __dir__)

    # TODO: document all the theme options
    # TODO: document neat tricky to use drafts folder on .gitignore
    # https://github.com/highlightjs/highlight.js/tree/master/src/styles
    CODE_THEME = 'atom-one-dark'

    def initialize(config = {})
      @config = config.transform_keys(&:to_sym).with_indifferent_access
    end

    def theme
      style = @theme || config[:theme]

      return unless style

      style = { name: style } if style.is_a?(String)

      Leter::Theme.new(style[:name] || Theme::DEFAULT).tap do |t|
        style.each do |key, value|
          t.set_attribute(key.to_s, value)
        end
      end
    end

    def google_analytics
      @google_analytics || config[:google_analytics]
    end

    def date_format
      @date_format || config[:date_format]
    end

    # html title tag
    # if empty takes from html
    def title
      @title || config[:title]
    end

    # html meta description
    # if empty takes from html
    def description
      @description || config[:description]
    end

    def css_url
      @css_url || config[:css_url] || Leter::Asset.local(:css).url
    end

    def code_theme
      @code_theme || code[:theme] || CODE_THEME
    end

    def to_yaml
      config.to_yaml
    end

    def self.filename
      'leter.yml'
    end

    def self.load(filename)
      config_yaml = YAML.safe_load(
        process_file(filename),
        [Symbol, ActiveSupport::HashWithIndifferentAccess]
      )

      new(config_yaml)
    rescue Errno::ENOENT
      raise Leter::NoConfigError
    end

    def self.process_file(filename)
      ERB.new(File.read(filename)).result
    end

    def self.default
      load(DEFAULT_CONFIG)
    end

    def self.default_config
      process_file(DEFAULT_CONFIG)
    end

    def custom(name)
      path = name.split('/').reject(&:empty?)

      custom_config = config
                      .fetch(:custom, {})
                      .with_indifferent_access
                      .dig(*path)

      AccountConfig.new(config.merge(custom_config || {}))
    end

    private

    def code
      config[:code] || {}
    end
  end
end
