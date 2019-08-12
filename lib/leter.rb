module Leter
  class Error < StandardError; end
  class NoConfigError < Error; end

  LAYOUT = File.read(File.expand_path('leter/layout.html.erb', __dir__))
  DATE_FORMAT = '%B %d, %Y'
  CSS = 'leter.css'

  require "leter/io"
  require "leter/version"
  require "leter/cli"
  require "leter/slug"
  require 'leter/page_builder'
  require 'leter/index_builder'
  require 'leter/website'
  require 'leter/config'
  require 'leter/account_config'
  require 'leter/markdown'
  require 'leter/html_template'
  require 'leter/index_template'
  require 'leter/index_item.rb'
  require 'leter/html.rb'
end
