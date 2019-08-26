# frozen_string_literal: true

module Leter
  class Theme
    attr_writer \
      :background_color,
      :page_align,
      :text_font,
      :text_color,
      :heading_font,
      :heading_color,
      :font_url

    THEME = File.read(File.expand_path('theme.css.erb', __dir__))
    DEFAULT = 'default'

    def initialize(name = DEFAULT)
      @name = name

      user_theme = self.class.load(name)

      @theme = default_theme.merge(user_theme).transform_keys(&:to_sym)
    end

    attr_reader :name

    def background_color
      @background_color || @theme[:background_color]
    end

    def page_align
      @page_align || @theme[:page_align]
    end

    def text_font
      @text_font || @theme[:text_font]
    end

    def text_color
      @text_color || @theme[:text_color]
    end

    def heading_font
      @heading_font || @theme[:heading_font]
    end

    def heading_color
      @heading_color || @theme[:heading_color]
    end

    def font_url
      @font_url || @theme[:font_url]
    end

    def to_css
      ERB.new(THEME).result(binding)
    end

    def self.list
      themes = File.expand_path('themes/*.yml', __dir__)

      Dir[themes].map { |t| File.basename(t, '.yml') }
    end

    def self.load(name)
      filename = File.basename(name, '.*') + '.yml'

      filepath = File.expand_path('themes/' + filename, __dir__)

      (YAML.safe_load(File.read(filepath)) || {}).tap do |t|
        t&.delete_if { |_k, v| v.nil? || v.empty? }
      end
    rescue Errno::ENOENT
      # TODO: own error class
      raise Leter::NoConfigError
    end

    def set_attribute(attr, value)
      send(attr + '=', value)
    end

    private

    def default_theme
      self.class.load('default.yml')
    end
  end
end
