require "observer"

require 'leter/account_config'
require 'leter/index_builder'
require 'leter/page_builder'
require 'leter/slug'
require 'leter/index_item'
require 'leter/html'
require 'leter/io'

module Leter
  class Website
    include Observable

    attr_reader :config, :status

    def initialize(config = Leter::AccountConfig.default)
      @config = config
    end

    def build
      notify('Building...')

      io = Leter::IO

      index_builder = Leter::IndexBuilder.new(config)

      io.list_files.each do |file|
        markdown = io.read_file(file)

        #TODO same constructor as index_builder 
        page_builder = Leter::PageBuilder.new(markdown, config)

        slug = Leter::Slug.new(file)
        updated_at = File.mtime(file)

        io.save_file(slug.to_s, page_builder.html) 

        item = Leter::IndexItem.new.tap do |i|
          i.title = page_builder.title
          i.url = slug.to_url
          i.updated_at = format_date(updated_at)
        end

        index_builder.add(root_folder(file), item)

        notify(file)
      end

      index_builder.run do |index_root, html|
        io.save_file("#{index_root}/index.html", html)

        notify("creating index for #{index_root}")
      end

      notify('Done!')
    end

    def clean
      io = Leter::IO

      io.list_files('html').each do |filename|
        html = io.read_file(filename)

        html = Leter::Html.new(html)

        #TODO remove hardcoded Leter
        if html.powered_by == 'Leter'
          io.delete_file(filename) 

          notify(filename)
        end
      end

      notify('Cleaned!')
    end

    private

    def notify(message)
      changed
      notify_observers(message)
    end

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
