# frozen_string_literal: true

module Leter
  class Color
    def self.hex_to_rgb(hex)
      clean_hex = hex[0] == '#' ? hex[1..7] : hex

      clean_hex.scan(/../).map { |v| Integer(v, 16) }
    end

    def self.hex_to_rgba_css(hex, opacity = 0)
      rgba = hex_to_rgb(hex) << opacity

      "rgba(#{rgba.join(', ')})"
    end
  end
end
