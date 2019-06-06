require 'active_support/core_ext/object/try'
require 'nokogiri'
require 'erb'

module Leter
  class PageBuilder
    LAYOUT = File.read("#{Dir.pwd}/lib/leter/layout.html.erb")

    def initialize(markdown, config = Leter::AccountConfig.default)
      @markdown = markdown
      @config = config
    end

    def html
      html_template = Leter::HtmlTemplate.new.tap do |h|
        h.title = title
        h.description = description
        h.body = content
        h.theme = @config.theme
      end

      ERB.new(LAYOUT).result(html_template.get_binding)
    end

    def content
      Leter::Markdown.new(@markdown).to_html
    end

    private

    def title
      first_h1 || first_h2
    end

    def description
      first_h2 || first_paragraph
    end

    def first_h1
      html_parser.at_css('h1').try(:text)
    end

    def first_h2
      html_parser.at_css('h2').try(:text)
    end

    def first_paragraph
      html_parser.at_css('p').try(:text)
    end

    def html_parser
      @html_parser ||= Nokogiri::HTML.parse(content)
    end
  end
end
