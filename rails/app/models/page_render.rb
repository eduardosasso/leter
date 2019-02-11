class PageRender
  # TODO, move somewhere else
  LAYOUT = File.read("#{Rails.root}/app/views/layouts/default.html.erb")

  def initialize(content, layout = LAYOUT)
    @content = content
    @layout = layout
  end

  def result
    render_layout do
      ERB.new(@content).result(binding)
    end
  end

  private

  def render_layout
    ERB.new(@layout).result(binding)
  end
end
