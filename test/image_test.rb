# frozen_string_literal: true

require 'test_helper'

require 'leter/image'

class ImageTest < Minitest::Test
  def test_resize
    Leter::Image.new('test/fixtures/image_1300x900.jpg').resize
    p Leter::Image.new('test/fixtures/image_1300x900.jpg').display_url
  end

  def test_original?
    assert(Leter::Image.new('test/fixtures/image_1300x900.jpg').original?)
    assert(!Leter::Image.new('test/fixtures/image_1300x900_L1024.jpg').original?)
  end
end
