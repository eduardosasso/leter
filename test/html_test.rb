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
end
