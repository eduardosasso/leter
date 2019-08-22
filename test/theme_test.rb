# frozen_string_literal: true

require 'test_helper'

require 'leter/theme'

class ThemeTest < Minitest::Test
  def test_css
    theme = Leter::Theme.new
    css = ":root {\n" \
          "  --background_color: #{theme.background_color};\n" \
          "  --page_align: #{theme.page_align};\n" \
          "  --text_font: #{theme.text_font};\n" \
          "  --text_color: #{theme.text_color};\n" \
          "  --heading_font: #{theme.heading_font};\n" \
          "  --heading_color: #{theme.heading_color};\n" \
          "  \n" \
          "}\n"

    assert_equal(css, theme.to_css)
  end

  def test_themes
    theme = Leter::Theme

    Leter::Theme.list.each do |t|
      assert((begin
                theme.new(t).to_css
              rescue StandardError
                nil
              end), "check theme #{t}")
    end
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
