# frozen_string_literal: true

require 'test_helper'

require 'leter/image_tag'

class ImageTagTest < Minitest::Test
  def test_html
    image = Leter::ImageTag.new.tap do |i|
      i.src = 'src'
      i.alt = 'alt'
      i.title = 'title'
    end

    html = Nokogiri::HTML.parse(image.html)

    assert(html.at_css('figure img'))
    assert(html.at_css('figure figcaption'))

    assert_equal('src', html.at_css('figure img').attr('src'))
    assert_equal('alt', html.at_css('figure figcaption').text)
  end
end
