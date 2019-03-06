require 'test_helper'

class AccountConfigTest < ActiveSupport::TestCase
  test 'default config' do
		config = AccountConfig.default

    assert_equal(config.theme, 'default') 
		assert_nil(config.google_analytics)
		assert(config.pro? == false)
  end

	test 'theme' do
    config_yml = {'theme' => 'banana'}
    config = AccountConfig.new(config_yml)

    assert_equal(config.theme, 'banana') 
	end
end
