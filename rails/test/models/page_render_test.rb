require 'test_helper'

class PageRenderTest < ActiveSupport::TestCase
  test 'page render' do
    page= 'aaaa' 
p    PageRender.new(page, nil).render
  end
end
