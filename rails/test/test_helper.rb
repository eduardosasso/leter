ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'
require 'rails/test_help'
require "minitest/spec"

DatabaseCleaner.strategy = :truncation

class Minitest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

module ActiveSupport
  class TestCase
    Minitest::Reporters.use!(
      Minitest::Reporters::DefaultReporter.new,
      ENV,
      Minitest.backtrace_filter
    )
    # Minitest::Reporters.use!

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    # fixtures :all
    # self.use_transactional_tests = true

    setup do
      DatabaseCleaner.start
    end
    
    teardown do
      DatabaseCleaner.clean
    end
    # before :each do
    #   DatabaseCleaner.start
    # end

    # after :each do
    #   DatabaseCleaner.clean
    # end

    # Add more helper methods to be used by all tests here...
  end
end
