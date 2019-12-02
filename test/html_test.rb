# frozen_string_literal: true

require 'test_helper'

class HtmlTest < Minitest::Test # rubocop:disable Metrics/ClassLength
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

    html = Leter::Markdown.new(markdown).to_html

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

    html = Leter::Markdown.new(markdown).to_html

    html_parser = Leter::Html.new(html)

    assert(html_parser.image?)
  end

  def test_image_singles
    markdown = <<~MD
      # Testing
      a single image

      ![alt 1](a1 "title 1")
      another single

      ![alt 2](a2 "title 2")
      ![alt 4](a4 "title 4")

      and one more

      ![alt 3](a3 'title 3')

      ## TLDR
      the end
    MD

    html = Leter::Markdown.new(markdown).to_html

    html_parser = Leter::Html.new(html)

    assert_equal(%w[a1 a3], html_parser.image_singles.collect(&:src))
  end

  # TODO: document it need empty line between stuff to check for single
  def test_images
    markdown = <<~MD
      # Testing
      a single image

      ![alt 1](a1 "title 1")

      another single

      ![alt 2](a2 "title 2")

      and one more

      ![alt 3](a3 'title 3')

      ## TLDR
      the end
    MD

    html = Leter::Markdown.new(markdown).to_html

    html_parser = Leter::Html.new(html)

    assert_equal(3, html_parser.images.size)
    assert(html_parser.images.first.single?)
  end

  def test_image_grup
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

    html = Leter::Markdown.new(markdown).to_html

    html_parser = Leter::Html.new(html)

    assert_equal(2, html_parser.image_group.size)
    assert_equal(%w[1 2 3], html_parser.image_group.first.to_a.map(&:src))
  end
end
