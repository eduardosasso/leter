# frozen_string_literal: true

require 'test_helper'
require 'leter/markdown'

class MarkdownTest < Minitest::Test
  def test_md_to_html
    text = '#hi'

    html = Leter::Markdown.new(text).to_html

    assert html
  end
end
