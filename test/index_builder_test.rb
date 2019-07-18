require 'test_helper'
require 'nokogiri'

class IndexBuilderTest < Minitest::Test
	def setup
		Leter::IO.save_file('blog/docker-compose/index.html','#index')
		Leter::IO.save_file('blog/vim/index.html','#vim')

		Leter::IO.save_file('articles/london/index.html','#london')
		Leter::IO.save_file('articles/paris/index.html','#paris')
	end

	def teardown
		Leter::IO.delete_all('blog/', 'articles/')
	end

	def test_add
		index_builder = Leter::IndexBuilder.new

		index_builder.add('blog/docker-compose/index.html', 'Playing with Docker Compose')
		index_builder.add('blog/vim/index.html', 'Learning Vim')

		index_builder.add('articles/london/index.html', 'Exploring London')
		index_builder.add('articles/paris/index.html', 'Walking in Paris')

		assert_equal(['blog', 'articles'], index_builder.index.keys)
		assert_equal(2, index_builder.index['blog'].count)
	end

	def test_html
		index_builder = Leter::IndexBuilder.new

		# index_builder.add('blog/docker-compose/index.html', 'Playing with Docker Compose')
		# index_builder.add('blog/vim/index.html', 'Learning Vim')

		index_builder.add('articles/london/index.html', 'Exploring London')
		index_builder.add('articles/paris/index.html', 'Walking in Paris')

		index_builder.html do |h|
			html = Nokogiri::HTML.parse(h)
			assert_equal(['Exploring London', 'Walking in Paris'], html.css('li').collect(&:text))
		end
	end
end
