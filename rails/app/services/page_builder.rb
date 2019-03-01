class PageBuilder
  LAYOUT = File.read("#{Rails.root}/app/views/layouts/default.html.erb")

  def initialize(markdown, config = nil)
    @markdown = markdown
    @config = config
  end

  def html
    content = Markdown.new(@markdown).to_html

    html_template = HtmlTemplate.new.tap do |h|
      h.title = 'title'
      h.description = 'description'
      h.body = content
      h.theme = 'banana'
    end

    ERB.new(LAYOUT).result(html_template.get_binding)
  end
end
