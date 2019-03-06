require 'test_helper'

class PageBuilderTest < ActiveSupport::TestCase
  test 'html page' do
    markdown = '# hello world'
    page_builder = PageBuilder.new(markdown)

    html = page_builder.html
    page = Nokogiri::HTML.parse(html)

    assert_equal(page.css('title').text, 'hello world')
    assert_equal(page.at('meta[name="description"]')['content'], '')
    assert_equal(page.css('h1').text, 'hello world')
    assert_equal(page.at('body')['id'], 'default')
  end

  test 'custom theme' do
    markdown = '# hello world'
    config = AccountConfig.new({theme: 'banana'})
    page_builder = PageBuilder.new(markdown, config)

    html = page_builder.html
    page = Nokogiri::HTML.parse(html)

    assert_equal(page.at('body')['id'], 'banana')
  end

  test 'description metatag' do
    markdown = <<~MD
      # hello world
      first paragraph

      second paragraph
    MD

    page_builder = PageBuilder.new(markdown)

    html = page_builder.html
    page = Nokogiri::HTML.parse(html)

    assert_equal(page.at('meta[name="description"]')['content'], 'first paragraph')
  end
end
