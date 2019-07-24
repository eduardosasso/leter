module Leter
  class Website
    attr_reader :config

    def initialize(config = Leter::AccountConfig.default)
      @config = config
    end

    def build
      io = Leter::IO

      index_builder = Leter::IndexBuilder.new(config)

      io.list_files.each do |file|
        markdown = io.read_file(file)

        #TODO same constructor as index_builder 
        page_builder = Leter::PageBuilder.new(markdown, config)

        url_path = Leter::Slug.new(file).to_s
        updated_at = File.mtime(file)

        io.save_file(url_path, page_builder.html) 

        item = Leter::IndexItem.new.tap do |i|
          i.title = page_builder.title
          i.url = url_path
          i.updated_at = format_date(updated_at)
        end

        index_builder.add(root_folder(file), item)
      end

      index_builder.run do |index_root, html|
        io.save_file("#{index_root}/index.html", html)
      end
    end

    def clean
      io = Leter::IO

      io.list_files('html').each do |filename|
        html = io.read_file(filename)

        html = Leter::Html.new(html)

        #TODO remove hardcoded Leter
        io.delete_file(filename) if html.powered_by == 'Leter'
      end
    end

    private

    def root_folder(file)
      Pathname(file)
        .dirname
        .split
        .collect(&:to_s)
        .reject{|e| e =~ /^.{1,2}$/}
        .first
    end

    def format_date(date)
      return nil unless config.date_format

      date.strftime(config.date_format)
    end
  end
end
