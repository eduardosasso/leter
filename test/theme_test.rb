# frozen_string_literal: true

require 'test_helper'

require 'leter/theme'

class ThemeTest < Minitest::Test
  def test_css
    theme = Leter::Theme.new
    css = ":root {\n" \
          "  --background-color: #{theme.background_color};\n" \
          "  --page-align: '#{theme.page_align}';\n" \
          "  --text-font: '#{theme.text_font}';\n" \
          "  --text-color: #{theme.text_color};\n" \
          "  --heading-font: #{theme.heading_font};\n" \
          "  --heading-color: #{theme.heading_color};\n" \
          "  \n" \
          "}\n"

    assert_equal(css, theme.to_css)
  end

  def test_attribute
    banana = Leter::Theme.load('banana.yml')

    theme = Leter::Theme.new('banana.yml')

    assert_equal(banana['text_color'], theme.text_color)
  end

  def test_default_attribute
    default = Leter::Theme.load('default.yml')

    theme = Leter::Theme.new('banana.yml')

    assert_equal(default['heading_color'], theme.heading_color)
  end
end
