# frozen_string_literal: true

require 'test_helper'

require 'leter/page_builder'
require 'leter/account_config'
require 'leter/config'
require 'date'

class PageBuilderTest < Minitest::Test # rubocop:disable Metrics/ClassLength
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

    assert_equal(css(theme), page.xpath('//style').text)
  end

  def test_font_url
    config = Leter::AccountConfig.new(theme: 'bungee')
    page_builder = Leter::PageBuilder.new('# hello world', config)

    page = Nokogiri::HTML.parse(page_builder.html)

    links = page.css('link').map(&:attributes).map { |m| m['href'].value }

    assert(links.include?(config.theme.font_url))
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
    config.css_url = '/root/leter.css'

    page_builder = Leter::PageBuilder.new(markdown, config)

    assert_match(config.css_url, page_builder.html)
  end

  def test_prod_css
    markdown = '# hello world'

    config = Leter::AccountConfig.default

    page_builder = Leter::PageBuilder.new(markdown, config)

    assert_match(Leter::Config.css_prod_url, page_builder.html)
  end

  def test_code
    markdown = <<~CODE
      ``` js
      var foo = function (bar) {
        return bar++;
      };

      console.log(foo(5));
      ```
    CODE

    config = Leter::AccountConfig.default

    page_builder = Leter::PageBuilder.new(markdown, config)

    assert_match(Leter::Asset.new(:highlightjs).url, page_builder.html)
  end

  def test_no_code
    markdown = '# hello'
    config = Leter::AccountConfig.default

    page_builder = Leter::PageBuilder.new(markdown, config)

    js = Leter::Asset.new(:highlightjs).url

    np_code_highlight = !page_builder.html.match?(js)

    assert(np_code_highlight)
  end

  def test_add_date
    markdown = <<~MD
      # hello world
      Testing
    MD

    page_builder = Leter::PageBuilder.new(markdown)

    page_builder.add_date(Date.today.to_s)

    assert_equal(Date.today.to_s, page_builder.date)
  end

  def test_dont_add_date
    # only add dates if there's an h1
    markdown = <<~MD
      Testing
    MD

    page_builder = Leter::PageBuilder.new(markdown)

    page_builder.add_date(Date.today.to_s)

    assert_nil(page_builder.date)
  end

  def test_images
    # TODO: list images and get their sizes
    # sequence of images together to form a carousel
    # convert individual pictures to form a figure tag?
    # for multiple pics remove the pics and initialize carousel
    # suppot for click/tap lightbox to show bigger version

    # markdown = <<~MD
    #   # Image Testing
    #   Lorem ipsum blablabla another paragraph
    #   ![Minion](https://octodex.github.com/images/minion.png "Minion image caption")
    # MD

    # page_builder = Leter::PageBuilder.new(markdown)
    # pp page_builder.html
  end

  def css(theme)
    ":root {\n" \
      "  --background_color: #{theme.background_color};\n" \
      "  --page_align: #{theme.page_align};\n" \
      "  --text_font: #{theme.text_font};\n" \
      "  --text_color: #{theme.text_color};\n" \
      "  --heading_font: #{theme.heading_font};\n" \
      "  --heading_color: #{theme.heading_color};\n" \
      "  --accent_color: #{theme.accent_color};\n" \
      "  --link_color: #{theme.link_color};\n" \
    "}\n"
  end
end
