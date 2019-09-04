# frozen_string_literal: true

require 'test_helper'

class HtmlTest < Minitest::Test
  def test_powered_by
    markdown = <<~MD
      # hello world
    MD

    page_builder = Leter::PageBuilder.new(markdown)

    html = page_builder.html

    html_parser = Leter::Html.new(html)

    assert_equal('Leter', html_parser.powered_by)
  end

  def test_title
    markdown = <<~MD
      # hello world
    MD

    page_builder = Leter::PageBuilder.new(markdown)

    html = page_builder.html

    html_parser = Leter::Html.new(html)

    assert_equal('hello world', html_parser.title)
  end

  def test_code
    markdown = <<~MD
      ``` ruby
      p 'hi'
      ```
    MD

    page_builder = Leter::PageBuilder.new(markdown)

    html = page_builder.html

    html_parser = Leter::Html.new(html)

    assert(html_parser.code?)
  end

  def test_no_code
    markdown = <<~MD
      ## no code block
    MD

    page_builder = Leter::PageBuilder.new(markdown)

    html = page_builder.html

    html_parser = Leter::Html.new(html)

    assert(!html_parser.code?)
  end
end
