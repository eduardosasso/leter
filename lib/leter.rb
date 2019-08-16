module Leter
  class Error < StandardError; end
  class NoConfigError < Error; end

  LAYOUT = File.read(File.expand_path('leter/layout.html.erb', __dir__))
  DATE_FORMAT = '%B %d, %Y'
  CSS = 'leter.css'

  require "leter/cli"
end
