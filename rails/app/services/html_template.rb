class HtmlTemplate
  attr_accessor :title, :description, :body, :theme

  # support templating of member data.
  def get_binding
    binding
  end
end
