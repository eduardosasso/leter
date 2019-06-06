# require 'test_helper'

# class PageBuilderTest < Minitest::Test
#   def test_html_page
#     markdown = '# hello world'
#     page_builder = Leter::PageBuilder.new(markdown)

#     html = page_builder.html
#     page = Nokogiri::HTML.parse(html)

#     assert_equal(page.css('title').text, 'hello world')
#     assert_equal(page.at('meta[name="description"]')['content'], '')
#     assert_equal(page.css('h1').text, 'hello world')
#     assert_equal(page.at('body')['id'], 'default')
#   end

#   def test_custom_theme
#     markdown = '# hello world'
#     config = Leter::AccountConfig.new({theme: 'banana'})
#     page_builder = Leter::PageBuilder.new(markdown, config)

#     html = page_builder.html
#     page = Nokogiri::HTML.parse(html)

#     assert_equal(page.at('body')['id'], 'banana')
#   end

#   def test_description_metatag
#     markdown = <<~MD
#       # hello world
#       first paragraph

#       second paragraph
#     MD

#     page_builder = Leter::PageBuilder.new(markdown)

#     html = page_builder.html
#     page = Nokogiri::HTML.parse(html)

#     assert_equal(page.at('meta[name="description"]')['content'], 'first paragraph')
#   end
# end
