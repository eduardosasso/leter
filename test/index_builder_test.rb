# frozen_string_literal: true

require 'test_helper'

require 'nokogiri'
require 'leter/index_builder'
require 'leter/io'
require 'leter/index_item'

class IndexBuilderTest < Minitest::Test
  def setup
    Leter::IO.save_file('blog/docker-compose/index.html', '#index')
    Leter::IO.save_file('blog/vim/index.html', '#vim')

    Leter::IO.save_file('articles/london/index.html', '#london')
    Leter::IO.save_file('articles/paris/index.html', '#paris')
  end

  def teardown
    Leter::IO.delete_all('blog/', 'articles/')
  end

  def test_add
    index_builder = Leter::IndexBuilder.new

    docker = Leter::IndexItem.new.tap do |i|
      i.title = 'Playing with Docker Compose'
    end

    vim = Leter::IndexItem.new.tap do |i|
      i.title = 'Learning Vim'
    end

    index_builder.add('blog', docker)
    index_builder.add('blog', vim)

    london = Leter::IndexItem.new.tap do |i|
      i.title = 'Learning Vim'
    end

    index_builder.add('articles', london)

    assert_equal(%w[blog articles], index_builder.index.keys)
    assert_equal(2, index_builder.index['blog'].count)
  end

  def test_html
    index_builder = Leter::IndexBuilder.new

    london = Leter::IndexItem.new.tap do |i|
      i.title = 'Exploring London'
      i.url = '/blog/london/index.html'
    end

    paris = Leter::IndexItem.new.tap do |i|
      i.title = 'Walking in Paris'
      i.url = '/blog/paris/index.html'
    end

    index_builder.add('articles', london)
    index_builder.add('articles', paris)

    index_builder.run do |_index_root, html|
      html_parser = Nokogiri::HTML.parse(html)

      assert_equal(['Exploring London', 'Walking in Paris'], html_parser.css('li').collect(&:text).collect(&:strip))
    end
  end
end
