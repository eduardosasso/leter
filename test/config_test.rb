require 'test_helper'

class ConfigTest < Minitest::Test
  def test_css_dev_path
    error = "missing CSS_DEV_PATH in .env file. Set it to #{Dir.pwd}/lib"

    assert(Leter::Config.css_dev_path, error)
  end

  def test_css_dev_url
    path = File.join(ENV['CSS_DEV_PATH'], '/leter.css')

    assert_equal(path, Leter::Config.css_dev_url)
  end

  def test_css_prod_path
    error = "missing CSS_PROD_PATH in .env file. Set it to https://{cdn_url}"

    assert(Leter::Config.css_prod_path, error)
  end

  def test_css_prod_url
    version = Leter::VERSION.gsub('.','_') 
    url = File.join(ENV['CSS_PROD_PATH'], "/leter_#{version}.css")

    assert_equal(url, Leter::Config.css_prod_url)  
  end
end
