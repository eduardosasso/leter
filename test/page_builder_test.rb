# frozen_string_literal: true

require 'test_helper'

require 'leter/page_builder'
require 'leter/account_config'
require 'leter/config'

class PageBuilderTest < Minitest::Test
  def test_html_page
    html = Leter::PageBuilder.new('# hello world').html
    page = Nokogiri::HTML.parse(html)

    assert_equal(page.css('title').text, 'hello world')
    assert_equal(page.at('meta[name="description"]')['content'], '')
    assert_equal(page.css('h1').text, 'hello world')
  end

  def test_custom_theme
    markdown = '# hello world'
    config = Leter::AccountConfig.new(theme: 'banana')
    page_builder = Leter::PageBuilder.new(markdown, config)

    html = page_builder.html
    page = Nokogiri::HTML.parse(html)

    assert_equal(page.at('body')['id'], 'banana')
  end

  def test_theme_vars
    config = Leter::AccountConfig.new(theme: 'banana')
    page_builder = Leter::PageBuilder.new('# hello world', config)

    page = Nokogiri::HTML.parse(page_builder.html)

    theme = config.theme

    css = ":root {\n" \
      "  --background_color: #{theme.background_color};\n" \
      "  --page_align: #{theme.page_align};\n" \
      "  --text_font: #{theme.text_font};\n" \
      "  --text_color: #{theme.text_color};\n" \
      "  --heading_font: #{theme.heading_font};\n" \
      "  --heading_color: #{theme.heading_color};\n" \
      "  \n" \
      "}\n"

    assert_equal(css, page.xpath('//style').text)
  end

  def test_description_metatag
    markdown = <<~MD
      # hello world
      first paragraph

      second paragraph
    MD

    page_builder = Leter::PageBuilder.new(markdown)

    html = page_builder.html
    page = Nokogiri::HTML.parse(html)

    assert_equal(page.at('meta[name="description"]')['content'], 'first paragraph')
  end

  def test_google_analytics
    markdown = '# hello world'

    config = Leter::AccountConfig.default
    config.google_analytics = 'UA-12345'

    page_builder = Leter::PageBuilder.new(markdown, config)

    html = page_builder.html

    assert_match(/ga\(\'create\', \"UA\-12345\"\, \'auto\'\)/, html)
  end

  def test_dev_css
    markdown = '# hello world'

    config = Leter::AccountConfig.default
    config.css_file_path = '/root/leter.css'

    page_builder = Leter::PageBuilder.new(markdown, config)

    assert_match(config.css_file_path, page_builder.html)
  end

  def test_prod_css
    markdown = '# hello world'

    config = Leter::AccountConfig.default

    page_builder = Leter::PageBuilder.new(markdown, config)

    assert_match(Leter::Config.css_prod_url, page_builder.html)
  end
end
