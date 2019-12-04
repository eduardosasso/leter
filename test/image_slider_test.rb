# frozen_string_literal: true

require 'test_helper'

class ImageSliderTest < Minitest::Test
  def test_script
    script = Leter::ImageSlider.new.script

    css = 'href="https://cdnjs.cloudflare.com/ajax/libs/Glide.js/3.4.1/css/glide.core.min.css"'
    theme = 'href="https://cdnjs.cloudflare.com/ajax/libs/Glide.js/3.4.1/css/glide.theme.min.css"'
    js = '<script async src="https://cdnjs.cloudflare.com/ajax/libs/Glide.js/3.4.1/glide.min.js">'

    assert_match(css, script)
    assert_match(theme, script)
    assert_match(js, script)
    assert_match('new Glide(\'.glide', script)
  end

  def test_html
    slider_html = Leter::ImageSlider.new.html(%w[a b c])

    html = Nokogiri::HTML.parse(slider_html)

    assert(html.at_css('div.glide'))

    assert(html.at_css('li.glide__slide'))
    assert(html.at_css('button.glide__bullet'))
  end
end
