# frozen_string_literal: true

require 'leter/color'

module Leter
  class Theme
    attr_writer \
      :description,
      :background_color,
      :page_align,
      :text_font,
      :text_color,
      :text_size,
      :heading_font,
      :heading_color,
      :font_url,
      :accent_color,
      :link_color

    attr_accessor :name

    THEME = File.read(File.expand_path('theme.css.erb', __dir__))
    DEFAULT = 'default'
    RGBA_OPACITY = 0.8
    TEXT_SIZE = '1.1em'

    PAGE_ALIGN = {
      center: '0 auto',
      left: '0px 0px 50px 50px'
    }.freeze

    def initialize(name = DEFAULT)
      @name = name

      user_theme = self.class.load(name)

      @theme = default_theme.merge(user_theme).transform_keys(&:to_sym)
    end

    def description
      @theme[:description]
    end

    def background_color
      @background_color || @theme[:background_color]
    end

    def page_align
      align = @page_align || @theme[:page_align]

      PAGE_ALIGN.fetch(align.try(:to_sym), PAGE_ALIGN[:center])
    end

    def text_font
      @text_font || @theme[:text_font]
    end

    def text_color
      @text_color || @theme[:text_color]
    end

    def text_size
      @text_size || @theme[:text_size] || TEXT_SIZE
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

    def accent_color
      @accent_color || @theme[:accent_color] || Color.hex_to_rgba_css(heading_color, RGBA_OPACITY)
    end

    def link_color
      @link_color || @theme[:link_color] || accent_color
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

    def self.print(comment = false)
      start = comment ? '# ' : ' '

      list.map do |theme|
        start + theme + new(theme).description.try(:prepend, ' - ').to_s
      end.join("\n")
    end

    def self.print_commented
      print(true)
    end

    private

    def default_theme
      self.class.load('default.yml')
    end
  end
end
