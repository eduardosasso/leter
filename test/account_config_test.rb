require 'test_helper'
require 'date'

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

  def test_debug
    config = Leter::AccountConfig.new.tap do |c|
      c.debug = true
    end.to_yaml
    
    new_config = YAML.load(config) 
    config = Leter::AccountConfig.new(new_config)

    assert(config.debug)
  end

  def test_no_debug
    config = Leter::AccountConfig.default

    assert(config.debug == false)
  end

  def test_load_config
    config = Leter::AccountConfig

    Leter::IO.save_file(config.filename, {'theme' => 'violet'}.to_yaml)

    assert_equal('violet', config.load(config.filename).theme)

    File.delete(config.filename)
  end

  def test_default_date_format
    config = Leter::AccountConfig.default
    date = Date.today 

    assert_equal(date.strftime(Leter::DATE_FORMAT), date.strftime(config.date_format))
  end
end
