require 'test_helper'

class SlugTest < ActiveSupport::TestCase
  test 'index' do
    slug = Slug.new('index.md').to_s

    assert slug == 'index.html'
  end

  test 'regular page' do
    slug = Slug.new('resume.md').to_s

    assert slug == 'resume/index.html'
  end

  test 'blog entry' do
    slug = Slug.new('blog/how_to_master_vim.md').to_s

    assert slug == 'blog/how-to-master-vim/index.html'
  end

  test 'index folder' do
    slug = Slug.new('blog/index/how_to_master_vim.md').to_s

    assert slug == 'blog/index/how-to-master-vim/index.html'
  end
end
