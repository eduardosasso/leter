# frozen_string_literal: true

require 'test_helper'
require 'leter/slug'

class SlugTest < Minitest::Test
  def test_index
    slug = Leter::Slug.new('index.md')

    assert_equal('index.html', slug.to_filename)
    assert_equal('/', slug.to_url)
  end

  def test_regular_page
    slug = Leter::Slug.new('resume.md')

    assert_equal('resume/index.html', slug.to_filename)
    assert_equal('/resume', slug.to_url)
  end

  def test_blog_entry
    slug = Leter::Slug.new('blog/how_to_master_vim.md')

    assert_equal('blog/how-to-master-vim/index.html', slug.to_filename)
    assert_equal('/blog/how-to-master-vim', slug.to_url)
  end

  def test_index_folder
    slug = Leter::Slug.new('blog/index/how_to_master_vim.md')

    assert_equal('blog/index/how-to-master-vim/index.html', slug.to_filename)
    assert_equal('/blog/index/how-to-master-vim', slug.to_url)
  end
end
