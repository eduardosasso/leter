require 'test_helper'

class AccountConfigTest < Minitest::Test
  def test_default_config
    config = Leter::AccountConfig.default

    assert_equal(config.theme, 'default')
    assert_nil(config.google_analytics)
    assert(config.pro? == false)
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

  def test_pro_account
    config = Leter::AccountConfig.new.tap { |c| c.pro = true }

    assert(config.pro?)
  end

  def test_pro_internal_only
    config = Leter::AccountConfig.new.tap { |c| c.pro = true }
    new_config = YAML.load(config.to_yaml)
    
    assert_empty(new_config)
  end
end
