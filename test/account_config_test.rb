# frozen_string_literal: true

require 'test_helper'

require 'date'
require 'leter/account_config'
require 'leter/io'

class AccountConfigTest < Minitest::Test
  def test_default_config
    config = Leter::AccountConfig.default

    assert_equal(config.theme.name, 'default')
    assert_nil(config.google_analytics)
  end

  def test_theme
    config_yml = { 'theme' => 'banana' }
    config = Leter::AccountConfig.new(config_yml)

    assert_equal(config.theme.name, 'banana')
  end

  def test_override_theme
    theme = {
      name: 'default',
      page_align: 'blabla'
    }

    config = { theme: theme }
    account_config = Leter::AccountConfig.new(config)

    assert_equal(theme[:page_align], account_config.theme.page_align)
  end
  # TODO: test override with non existent attr

  def test_new_config
    new_config = { theme: 'banana', google_analytics: 123 }

    config = Leter::AccountConfig.new(new_config)

    assert_equal(config.theme.name, 'banana')
    assert_equal(config.google_analytics, 123)
  end

  def test_css_file_path
    new_config = { 'css_file_path' => '/root/leter.css' }

    config = Leter::AccountConfig.new(new_config)

    assert(config.css_file_path)
  end

  def test_no_css_file_path
    config = Leter::AccountConfig.default

    assert_nil(config.css_file_path)
  end

  def test_load_config
    config = Leter::AccountConfig

    Leter::IO.save_file(config.filename, { 'theme' => 'banana' }.to_yaml)

    theme = config.load(config.filename).theme

    assert_equal('banana', theme.name)

    File.delete(config.filename)
  end

  def test_default_date_format
    config = Leter::AccountConfig.default
    date = Date.today

    assert_equal(date.strftime(Leter::DATE_FORMAT), date.strftime(config.date_format))
  end

  def test_default_code_theme
    config = Leter::AccountConfig.default

    assert_equal(Leter::AccountConfig::CODE_THEME, config.code_theme)
  end

  def test_code_theme
    config = Leter::AccountConfig

    code = { theme: 'dark' }

    Leter::IO.save_file(config.filename, { 'theme' => 'banana', code: code }.to_yaml)

    code_theme = config.load(config.filename).code_theme

    assert_equal('dark', code_theme)

    File.delete(config.filename)
  end
end
