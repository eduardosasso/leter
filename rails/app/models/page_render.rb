class PageRender
  def initialize(content, layout)
    @content = content
    @layout = layout
  end

  def render
    render_layout do
      ERB.new(@content).result(binding)
    end
    # ERB.new(
  end

  private

  def render_layout
layout = "<html>
<head>
  <title>Layout</title>
</head>
<body>
  <%= yield %>
</body>
</html>"

ERB.new(layout).result(binding)
  end

  def render_template
    # ERB
  end
end
