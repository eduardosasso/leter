# frozen_string_literal: true

require 'test_helper'
require 'leter/code'

class CodeTest < Minitest::Test
  def test_script
    config = Leter::AccountConfig.new(theme: 'banana')

    code = Leter::Code.new(config).script

    js = Leter::Asset.new(:highlightjs).url

    assert_match(js, code)
    assert_match('hljs.highlightBlock', code)
  end

  def test_script_css
    code = { theme: 'dark' }

    config = Leter::AccountConfig.new(theme: 'banana', code: code)

    script = Leter::Code.new(config).script

    css = Leter::Asset.new(:highlightjs).path + 'styles/dark.min.css'

    assert_match(css, script)
  end
end
