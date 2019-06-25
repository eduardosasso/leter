require 'test_helper'

class AccountConfigTest < Minitest::Test
  def test_default_config
    config = Leter::AccountConfig.default

    assert_equal(config.theme, 'default')
    assert_nil(config.google_analytics)
  end

  def test_theme
    config_yml = { 'theme' => 'banana' }
    config = Leter::AccountConfig.new(config_yml)

    assert_equal(config.theme, 'banana')
  end

  def test_new_config
    config = Leter::AccountConfig.new.tap do |c|
      c.theme = 'fancy'
      c.google_analytics = 123
    end.to_yaml
    
    new_config = YAML.load(config) 
    config = Leter::AccountConfig.new(new_config)

    assert_equal(config.theme, 'fancy')
    assert_equal(config.google_analytics, 123)
  end

  def test_load_config
    config = Leter::AccountConfig

    Leter::IO.save_file(config.filename, {'theme' => 'violet'}.to_yaml)

    assert_equal('violet', config.load(config.filename).theme)

    File.delete(config.filename)
  end
end
