module Leter
  class Error < StandardError; end

  LAYOUT = File.read(File.expand_path('leter/layout.html.erb', __dir__))

  require "leter/io"
  require "leter/version"
  require "leter/cli"
  require "leter/slug"
  require 'leter/page_builder'
  require 'leter/index_builder'
  require 'leter/website'
  require 'leter/account_config'
  require 'leter/markdown'
  require 'leter/html_template'
  require 'leter/index_template'
end
