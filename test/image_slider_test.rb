# frozen_string_literal: true

require 'test_helper'

class ImageSliderTest < Minitest::Test
  def test_script
    script = Leter::ImageSlider.new.script

    css = 'href="https://cdnjs.cloudflare.com/ajax/libs/Glide.js/3.4.1/css/glide.core.min.css"'
    js = '<script async src="https://cdnjs.cloudflare.com/ajax/libs/Glide.js/3.4.1/glide.min.js">'

    assert_match(css, script)
    assert_match(js, script)
    assert_match('new Glide(\'.glide\').mount()', script)
  end
end
