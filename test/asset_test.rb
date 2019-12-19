# frozen_string_literal: true

require 'test_helper'
require 'leter/asset'

class AssetTest < Minitest::Test
  def test_url
    asset = Leter::Asset.new(:highlightjs)

    url = "jsdelivr.net/gh/highlightjs/cdn-release@#{asset.version}/build/highlight.min.js"

    assert_match(url, asset.url)
  end

  def test_package
    asset = Leter::Asset.new(:normalize)

    assert_equal('npm/normalize.css', asset.package)
  end

  def test_version
    asset = Leter::Asset.new(:normalize)

    assert_match(/^\d{1}.\d{1}.\d{1}$/, asset.version)
  end

  def test_path
    asset = Leter::Asset.new(:highlightjs)

    path = asset.url.gsub('highlight.min.js', '')

    assert_equal(path, asset.path)
  end

  def test_local_css
    asset = Leter::Asset.local(:css)

    css = "leter@#{Leter::VERSION}/lib/leter/assets/leter.css"

    assert_match(css, asset.url)
  end
end
