class Markdown
  def initialize(text)
    @text = text
  end

  def to_html
    Kramdown::Document.new(@text).to_html
  end

  def self.is?(filename)
    File.extname(filename).in?(['.md','.markdown'])
  end
end
