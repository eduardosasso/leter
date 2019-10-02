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

  def test_multiple_h1
    markdown = <<~MD
      # hello one
      # hello two
      # hello three
    MD

    page_builder = Leter::PageBuilder.new(markdown)

    html = page_builder.html

    html_parser = Leter::Html.new(html)

    assert_equal('hello one', html_parser.first_h1.text)
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

  def test_image
    markdown = <<~MD
      # Testing
      a single image
      ![Minion0](https://octodex.github.com/images/minion.png)
      ## more text
      another paragraph
    MD

    page_builder = Leter::PageBuilder.new(markdown)

    html = page_builder.html

    html_parser = Leter::Html.new(html)

    assert(html_parser.image?)
  end

  def test_image_chain
    markdown = <<~MD
      # Testing
      a single image

      ![1](1)
      ![2](2)
      ![3](3)

      another paragraph

      ### header
      some copy

      ```ruby
      p "hello"
      ```

      ![4](4)
      ![5](5)

      ## TLDR
      the end
    MD

    page_builder = Leter::PageBuilder.new(markdown)

    html = page_builder.html

    html_parser = Leter::Html.new(html)

    assert_equal(2, html_parser.image_chain.size)
    assert_equal(%w[1 2 3], html_parser.image_chain.first.to_a.map { |c| c.attr('src') })
  end
end
