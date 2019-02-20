require 'test_helper'

class MarkdownTest < ActiveSupport::TestCase
  test 'generate html' do
    text = file_fixture('markdown.md').read

    html = Markdown.new(text).to_html

    assert html
  end
end
