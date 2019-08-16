require 'test_helper'

require 'leter/config'

class ConfigTest < Minitest::Test
  def test_css_prod_url
    version = Leter::VERSION.gsub('.','_') 
    url = File.join(Leter::Config::CSS_PROD_PATH, "/leter_#{version}.css")

    assert_equal(url, Leter::Config.css_prod_url)  
  end
end
