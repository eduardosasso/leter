require 'test_helper'

class PageRenderTest < ActiveSupport::TestCase
  test 'page render' do
    content = 'test'

    page_render = PageRender.new(content).result

    assert_match('html', page_render)
    assert_match(content, page_render)
  end
end
