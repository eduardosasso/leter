require 'test_helper'

class PageBuilderTest < ActiveSupport::TestCase
  test 'html page' do
    markdown = '# hello world'
    page_builder = PageBuilder.new(markdown)

    html = page_builder.html
    page = Nokogiri::HTML.parse(html)

    assert_equal(page.css('title').text, 'title')
    assert_equal(page.at('meta[name="description"]')['content'], 'description')
    assert_equal(page.css('h1').text, 'hello world')
  end
end
