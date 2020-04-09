# frozen_string_literal: true

require 'observer'

require 'leter/account_config'
require 'leter/index_builder'
require 'leter/page_builder'
require 'leter/slug'
require 'leter/index_item'
require 'leter/html'
require 'leter/io'
require 'pathname'

module Leter
  class Website
    include Observable

    Page = Struct.new(:builder, :slug, :date, :root_folder)

    attr_reader :config, :status

    def initialize(config = AccountConfig.default)
      @config = config
    end

    def build(name = nil)
      list = name ? files.grep(/#{name}/i) : files

      list.each do |file|
        updated_at = File.mtime(file)

        page = Page.new(
          page_builder(file),
          slug(file),
          updated_at,
          root_folder(file)
        )

        add_page(page)

        add_index(page)

        notify(file)
      end

      build_index
    end

    def clean
      IO.list_files('html').each do |filename|
        html = IO.read_file(filename)

        html = Html.new(html)

        # TODO: remove hardcoded Leter
        next unless html.powered_by == 'Leter'

        IO.delete_file(filename)

        notify(filename)
      end
    end

    def files
      IO.list_files
    end

    private

    def custom_page_config(file)
      config.custom(slug(file).to_s)
    end

    def slug(file)
      Slug.new(file)
    end

    def page_builder(file)
      markdown = IO.read_file(file)

      PageBuilder.new(markdown, custom_page_config(file))
    end

    def add_page(page)
      html = page.builder.tap do |p|
        # add date only for non index pages
        p.add_date(format_date(page.date, p.config.date_format)) unless page.slug.index?
      end.html

      IO.save_file(page.slug.to_filename, html)
    end

    def add_index(page)
      item = IndexItem.new.tap do |i|
        i.title = page.builder.title
        i.url = page.slug.to_url
        i.updated_at = format_date(page.date)
      end

      index_builder.add(page.root_folder, item)
    end

    def build_index
      index_builder.run do |index_root, html|
        IO.save_file("#{index_root}/index.html", html)
      end
    end

    def index_builder
      @index_builder ||= IndexBuilder.new(config)
    end

    def notify(message)
      changed
      notify_observers(message)
    end

    def root_folder(file)
      Pathname.new(file)
        .dirname
        .split
        .collect(&:to_s)
        .reject { |e| e =~ /^.{1,2}$/ }
        .first
    end

    def format_date(date, format = config.date_format)
      return nil unless format

      date.strftime(format)
    end
  end
end
