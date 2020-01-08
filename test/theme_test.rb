# frozen_string_literal: true

require 'test_helper'

require 'leter/theme'
require 'leter/color'

class ThemeTest < Minitest::Test
  def test_css
    theme = Leter::Theme.new
    css = ":root {\n" \
          "  --background_color: #{theme.background_color};\n" \
          "  --page_align: #{theme.page_align};\n" \
          "  --text_font: #{theme.text_font};\n" \
          "  --text_color: #{theme.text_color};\n" \
          "  --text_size: #{theme.text_size};\n" \
          "  --heading_font: #{theme.heading_font};\n" \
          "  --heading_color: #{theme.heading_color};\n" \
          "  --accent_color: #{theme.accent_color};\n" \
          "  --link_color: #{theme.link_color};\n" \
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

  def test_print_themes
    theme = Leter::Theme

    classic = Leter::Theme.new('classic')

    assert_match(classic.description, theme.print)
  end

  def test_default_attribute
    default = Leter::Theme.load('default.yml')

    theme = Leter::Theme.new('banana.yml')

    assert_equal(default['heading_color'], theme.heading_color)
  end

  def test_accent_color_rgba
    theme = Leter::Theme.new('bungee')

    rgba_css = Leter::Color.hex_to_rgba_css(theme.heading_color, Leter::Theme::RGBA_OPACITY)

    assert_equal(rgba_css, theme.accent_color)
  end

  def test_accent_color
    theme = Leter::Theme.new('bungee')
    theme.accent_color = 'brown'

    assert_equal('brown', theme.accent_color)
  end

  def test_link_color
    theme = Leter::Theme.new('bungee')
    theme.link_color = 'brown'

    assert_equal('brown', theme.link_color)
  end

  def test_default_link_color
    theme = Leter::Theme.new('bungee')
    theme.accent_color = 'blue'

    assert_equal('blue', theme.link_color)
  end

  def test_page_align_center
    theme = Leter::Theme.new('bungee')
    theme.page_align = 'center'

    assert_equal(Leter::Theme::PAGE_ALIGN[:center], theme.page_align)
  end

  def test_page_align_left
    theme = Leter::Theme.new('bungee')
    theme.page_align = 'left'

    assert_equal(Leter::Theme::PAGE_ALIGN[:left], theme.page_align)
  end
end
