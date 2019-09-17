# frozen_string_literal: true

require 'test_helper'
require 'leter/code'

class CodeTest < Minitest::Test
  def test_result
    config = Leter::AccountConfig.new(theme: 'banana')

    code = Leter::Code.new(config).result

    js = Leter::Asset.new(:highlightjs).url
    font = Leter::Asset.new(:hack_font).url

    assert_match(js, code)
    assert_match('hljs.highlightBlock', code)
    assert_match(font, code)
  end

  def test_result_css
    code = { theme: 'dark' }

    config = Leter::AccountConfig.new(theme: 'banana', code: code)

    result = Leter::Code.new(config).result

    css = Leter::Asset.new(:highlightjs).path + '/styles/dark.min.css'

    assert_match(css, result)
  end
end
