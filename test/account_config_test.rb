# frozen_string_literal: true

require 'test_helper'

require 'date'
require 'leter/account_config'
require 'leter/io'

class AccountConfigTest < Minitest::Test # rubocop:disable Metrics/ClassLength
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
      name: 'crest',
      page_align: 'left'
    }

    config = { theme: theme }
    account_config = Leter::AccountConfig.new(config)

    assert_equal(Leter::Theme::PAGE_ALIGN[:left], account_config.theme.page_align)
    assert_equal('crest', account_config.theme.name)
  end
  # TODO: test override with non existent attr

  def test_new_config
    new_config = { theme: 'banana', google_analytics: 123 }

    config = Leter::AccountConfig.new(new_config)

    assert_equal(config.theme.name, 'banana')
    assert_equal(config.google_analytics, 123)
  end

  def test_css_url
    new_config = { 'css_url' => '/root/leter.css' }

    config = Leter::AccountConfig.new(new_config)

    assert(config.css_url)
  end

  def test_default_css_url
    config = Leter::AccountConfig.default

    assert_equal(Leter::Asset.local(:css).url, config.css_url)
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

  def test_title_and_description
    config = Leter::AccountConfig
    options = { 'title' => 'clean title', 'description' => 'nice description' }.to_yaml

    Leter::IO.save_file(config.filename, options)

    site = config.load(config.filename)

    assert_equal('clean title', site.title)
    assert_equal('nice description', site.description)

    File.delete(config.filename)
  end

  def test_custom_page_title_and_description
    account_config = Leter::AccountConfig

    new_config = {
      theme: 'banana',
      title: 'plain old',
      custom: {
        index: {
          title: 'hello world',
          description: 'going to the moon'
        }
      }
    }

    Leter::IO.save_file(account_config.filename, new_config.to_yaml)

    config = Leter::AccountConfig.load(account_config.filename)

    custom_config = config.custom('index')

    assert_equal('hello world', custom_config.title)
    assert_equal('going to the moon', custom_config.description)

    File.delete(account_config.filename)
  end

  def test_custom_page
    account_config = Leter::AccountConfig

    new_config = {
      theme: 'banana',
      google_analytics: 123,
      date_format: 'xxx',
      custom: {
        index: {
          theme: 'crest',
          date_format: 'abc'
        }
      }
    }

    Leter::IO.save_file(account_config.filename, new_config.to_yaml)

    config = Leter::AccountConfig.load(account_config.filename)

    custom_config = config.custom('index')

    assert_equal('crest', custom_config.theme.name)
    assert_equal('abc', custom_config.date_format)

    File.delete(account_config.filename)
  end

  def test_no_custom_page
    new_config = {
      theme: 'banana',
      google_analytics: 123
    }

    config = Leter::AccountConfig.new(new_config)

    assert_equal('banana', config.custom('index').theme.name)
  end
end
