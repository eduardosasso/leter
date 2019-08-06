require 'test_helper'
require 'date'

class WebsiteTest < Minitest::Test
  def teardown
    Leter::IO.delete_all('blog/', 'tmp/', 'readme/')
  end

  def test_build
    Leter::IO.save_file('tmp/test/index.md','# index')
    Leter::IO.save_file('tmp/test/resume.md','# resume')

    Leter::Website.new.build

    index = Leter::IO.read_file('tmp/test/index.html')
    resume = Leter::IO.read_file('tmp/test/resume/index.html')

    assert(index)
    assert(resume)

    assert_equal("resume", Leter::Html.new(resume).title)
  end

  def test_index_catalog
    Leter::IO.save_file('blog/news.md','# news')
    Leter::IO.save_file('blog/vim_tips.md','# vim tips')

    Leter::Website.new.build

    blog_index = Leter::IO.read_file('blog/index.html')

    assert(blog_index)
  end

  def test_index_item_date
    Leter::IO.save_file('blog/vim_tips.md','# vim tips')

    Leter::Website.new.build

    blog_index = Leter::IO.read_file('blog/index.html')

    html = Leter::Html.new(blog_index)

    index_item_updated_at = html.parser.at_css("div#updated_at").text.strip

    updated_at = Date.today.strftime(Leter::DATE_FORMAT)

    assert_equal(updated_at, index_item_updated_at)
  end

  def test_index_item_no_date
    Leter::IO.save_file('blog/vim_tips.md','# vim tips')

    config = Leter::AccountConfig.new

    Leter::Website.new(config).build

    blog_index = Leter::IO.read_file('blog/index.html')

    html = Leter::Html.new(blog_index)

    index_item_updated_at = html.parser.at_css("div#updated_at")

    assert_nil(index_item_updated_at)
  end


  def test_clean
    Leter::IO.save_file('tmp/clean/site/index.md','# index')
    Leter::IO.save_file('tmp/clean/site/resume.md','# resume')
    Leter::IO.save_file('tmp/clean/site/blog/docker_tutorial.md','# docker tutorial')

    Leter::Website.new.tap do |w|
      w.build
      w.clean
    end

    assert(Dir["tmp/clean/site/**/*.html"].empty?)
  end
end
