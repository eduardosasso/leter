# frozen_string_literal: true

require 'test_helper'

require 'leter/cli'

class CliTest < Minitest::Test
  include Aruba::Api
  def setup
    setup_aruba
  end

  def test_usage_instructions
    run_command_and_stop('leter')

    assert_match(/Usage: leter/, last_command_started.output)
  end

  def test_new_project
    run_command_and_stop('leter --new')

    assert_match(/leter.yml created/, last_command_started.output)
    assert(read(Leter::AccountConfig.filename))
  end

  def test_project_exists
    write_file(Leter::AccountConfig.filename, '')

    run_command_and_stop('leter --new')

    assert_match(/already exists/, last_command_started.output)
  end

  def test_project_build
    run_command_and_stop('leter --new')

    run_command_and_stop('leter --build')

    assert_match(/Done!/, last_command_started.output)
  end

  def test_project_themes
    run_command_and_stop('leter --themes')

    assert_match(/classic/, last_command_started.output)
  end

  def test_project_build_no_config
    run_command_and_stop('leter --build')

    assert_match(/leter.yml not found!/, last_command_started.output)
  end

  def test_project_clean
    run_command_and_stop('leter --new')

    run_command_and_stop('leter --clean')

    assert_match(/Cleaned!/, last_command_started.output)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Leter::VERSION
  end
end
