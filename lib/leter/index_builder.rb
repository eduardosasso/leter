module Leter
  class IndexBuilder
    attr_reader :index

    def initialize(config = Leter::AccountConfig.default)
      @config = config
      @index = {}
    end

    def add(path, title)
      # break path in root and store by key with names and url hash
      # {"/blog" => {title: "Docker", url: "/blog/docker/index.html"}
      # save to template
      # extract date from file
      # reading time

      root = Pathname(path).dirname.split.first.to_s

      (@index[root] ||= []) << {title: title, url: path}
    end

    def html
      # takes a block that can be used to save the file to disk
      # loop on index keys
      # indextemplate to generate ul/li html
      # pass indextemplate to html template
      
      index_template = Leter::IndexTemplate.new.tap do |h|
        h.items = content
        h.theme = @config.theme
      end

      ERB.new(Leter::LAYOUT).result(index_template.get_binding)
    end
  end
end
