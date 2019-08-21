# frozen_string_literal: true

require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'leter'

require 'minitest/autorun'
require 'minitest/pride'
require 'aruba/api'
