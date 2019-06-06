require 'test_helper'

class SlugTest < Minitest::Test
  def test_index
    slug = Leter::Slug.new('index.md').to_s

    assert slug == 'index.html'
  end

  def test_regular_page
    slug = Leter::Slug.new('resume.md').to_s

    assert slug == 'resume/index.html'
  end

  def test_blog_entry
    slug = Leter::Slug.new('blog/how_to_master_vim.md').to_s

    assert slug == 'blog/how-to-master-vim/index.html'
  end

  def test_index_folder
    slug = Leter::Slug.new('blog/index/how_to_master_vim.md').to_s

    assert slug == 'blog/index/how-to-master-vim/index.html'
  end
end
