# frozen_string_literal: true

module Leter
  class Error < StandardError; end
  class NoConfigError < Error; end

  # TODO: move this to its own place
  # TODO check lint for unused stuff to remove
  LAYOUT = File.read(File.expand_path('leter/layout.html.erb', __dir__))
  # TODO: document possible formats https://ruby-doc.org/stdlib-2.6.1/libdoc/date/rdoc/DateTime.html#method-i-strftime
  DATE_FORMAT = '%B %d, %Y'
  CSS = 'leter.css'

  require 'leter/cli'
end
