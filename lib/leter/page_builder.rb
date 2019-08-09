require 'active_support/core_ext/object/try'
require 'nokogiri'
require 'erb'

module Leter
  class PageBuilder
    LAYOUT = File.read(File.expand_path('layout.html.erb', __dir__))

    def initialize(markdown, config = Leter::AccountConfig.default)
      @markdown = markdown
      @config = config
    end

    def html
      html_template = Leter::HtmlTemplate.new.tap do |h|
        h.title = title
        h.description = description
        h.body = content
        h.config = @config
      end

      ERB.new(LAYOUT).result(html_template.get_binding)
    end

    def title
      html_parser.title
    end

    def description
      html_parser.description
    end

    def content
      Leter::Markdown.new(@markdown).to_html
    end

    def html_parser
      Leter::Html.new(content)
    end
  end
end
