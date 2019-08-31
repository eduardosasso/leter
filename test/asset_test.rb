# frozen_string_literal: true

require 'test_helper'
require 'leter/asset'

class AssetTest < Minitest::Test
  def test_url
    asset = Leter::Asset.new(:highlightjs)

    url = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/#{asset.version}/highlight.min.js"

    assert_equal(url, asset.url)
  end

  def test_package
    asset = Leter::Asset.new(:normalize)

    assert_equal('normalize', asset.package)
  end

  def test_version
    asset = Leter::Asset.new(:normalize)

    assert_match(/^\d{1}.\d{1}.\d{1}$/, asset.version)
  end

  def test_path
    asset = Leter::Asset.new(:highlightjs)

    path = asset.url.gsub('/highlight.min.js', '')

    assert_equal(path, asset.path)
  end
end
