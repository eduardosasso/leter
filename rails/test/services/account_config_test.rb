require 'test_helper'

class AccountConfigTest < ActiveSupport::TestCase
  test 'default config' do
    config = AccountConfig.default

    assert_equal(config.theme, 'default')
    assert_nil(config.google_analytics)
    assert(config.pro? == false)
  end

  test 'theme' do
    config_yml = { 'theme' => 'banana' }
    config = AccountConfig.new(config_yml)

    assert_equal(config.theme, 'banana')
  end

  test 'new config' do
    config = AccountConfig.new.tap do |c|
      c.theme = 'fancy'
      c.google_analytics = 123
    end.to_yaml
    
    new_config = YAML.load(config) 
    config = AccountConfig.new(new_config)

    assert_equal(config.theme, 'fancy')
    assert_equal(config.google_analytics, 123)
  end

  test 'pro account' do
    config = AccountConfig.new.tap { |c| c.pro = true }

    assert(config.pro?)
  end

  test 'pro internal only' do
    config = AccountConfig.new.tap { |c| c.pro = true }
    new_config = YAML.load(config.to_yaml)
    
    assert_empty(new_config)
  end
end
