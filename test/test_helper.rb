# frozen_string_literal: true

$VERBOSE = nil

require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'leter'

require 'minitest/autorun'
require 'aruba/api'
require 'minitest/reporters'

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new(color: true)]
