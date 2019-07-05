require 'test_helper'

class IndexBuilderTest < Minitest::Test
  def test_add
    index_builder = Leter::IndexBuilder.new

    index_builder.add('/blog/docker-compose/index.html', 'Playing with Docker Compose')
    index_builder.add('/blog/vim/index.html', 'Learning Vim')

    index_builder.add('/articles/london/index.html', 'Exploring London')
    index_builder.add('/articles/paris/index.html', 'Walking in Paris')

    assert_equal(['/blog', '/articles'], index_builder.index.keys)
    assert_equal(2, index_builder.index['/blog'].count)
  end
end
