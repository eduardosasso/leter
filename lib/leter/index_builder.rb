module Leter
  class IndexBuilder
    attr_reader :index

    INDEX_PARTIAL = File.read(File.expand_path('_index.html.erb', __dir__))

    def initialize(config = Leter::AccountConfig.default)
      @config = config
      @index = {}
    end

    def add(path, title)
      #TODO reading time only if greater than like 2 min

      root = Pathname(path).dirname.split.first.to_s
      updated_at = File.mtime(path)

      #TODO struct or poro
      (@index[root] ||= []) << {title: title, url: path, updated_at: updated_at}
    end

    def html(&block)
      # takes a block that can be used to save the file to disk

      html_template = Leter::HtmlTemplate.new.tap do |h|
        h.theme = @config.theme
      end

      index.each do |index_title, items|
        html_template.tap do |h|
          h.title = index_title
          h.body = index_html(items) 
        end

        html = ERB.new(Leter::LAYOUT).result(html_template.get_binding)

        block.call(html)
      end

      nil
    end

    private

    def index_html(items)
      index_template = Leter::IndexTemplate.new.tap do |index|
        #TODO pass title to render as h1
        index.items = items 
      end

      ERB.new(INDEX_PARTIAL).result(index_template.get_binding)
    end
  end
end
