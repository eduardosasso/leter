# frozen_string_literal: true

require 'test_helper'
require 'leter/color'

class ColorTest < Minitest::Test
  def test_hex_to_rgba
    hex = '#ff4500'

    rgba_css = Leter::Color.hex_to_rgba_css(hex, 0.4)

    assert_equal('rgba(255, 69, 0, 0.4)', rgba_css)
  end
end
