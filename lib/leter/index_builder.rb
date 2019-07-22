module Leter
  class IndexBuilder
    attr_reader :index

    INDEX_PARTIAL = File.read(File.expand_path('_index.html.erb', __dir__))

    def initialize(config = Leter::AccountConfig.default)
      @config = config
      @index = {}
    end

    def add(key, item = Leter::Item)
      #TODO reading time only if greater than like 2 min

      (@index[key] ||= []) << item if key 
    end

    def run(&block)
      # takes a block that can be used to save the file to disk

      html_template = Leter::HtmlTemplate.new.tap do |h|
        h.theme = @config.theme
      end

      index.each do |key, items|
        html_template.tap do |h|
          h.title = key
          h.body = index_html(key, items) 
        end

        html = ERB.new(Leter::LAYOUT).result(html_template.get_binding)

        block.call(key, html)
      end

      nil
    end

    private

    def index_html(root, items)
      index_template = Leter::IndexTemplate.new.tap do |index|
        #TODO pass title to render as h1
        #partial with link on li and date
        index.root = root
        index.items = items 
      end

      ERB.new(INDEX_PARTIAL).result(index_template.get_binding)
    end
  end
end
