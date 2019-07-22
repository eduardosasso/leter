require 'test_helper'

class WebsiteTest < Minitest::Test
  def teardown
    Leter::IO.delete_all('blog/', 'tmp/', 'readme/')
  end

  def test_build
    Leter::IO.save_file('tmp/test/index.md','#index')
    Leter::IO.save_file('tmp/test/resume.md','#resume')

    Leter::Website.new.build

    index = Leter::IO.read_file('tmp/test/index.html')
    resume = Leter::IO.read_file('tmp/test/resume/index.html')

    #TODO should also assert the content
    #maybe extract html parsing from pagebuilder in its own class
    assert(index)
    assert(resume)
  end

  def test_index_catalog
    Leter::IO.save_file('blog/news.md','#news')
    Leter::IO.save_file('blog/vim_tips.md','#vim tips')

    Leter::Website.new.build

    blog_index = Leter::IO.read_file('blog/index.html')

    assert(blog_index)
  end

  def test_clean
    Leter::IO.save_file('tmp/clean/site/index.md','#index')
    Leter::IO.save_file('tmp/clean/site/resume.md','#resume')
    Leter::IO.save_file('tmp/clean/site/blog/docker_tutorial.md','#docker tutorial')

    Leter::Website.new.tap do |w|
      w.build
      w.clean
    end

    assert(Dir["tmp/clean/site/**/*.html"].empty?)
  end
end
