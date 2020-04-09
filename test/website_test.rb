# frozen_string_literal: true

require 'test_helper'
require 'date'

require 'leter/io'
require 'leter/website'

class WebsiteTest < Minitest::Test
  def teardown
    Leter::IO.delete_all('blog/', 'tmp/', 'readme/')
  end

  def test_build
    Leter::IO.save_file('tmp/test/index.md', '# index')
    Leter::IO.save_file('tmp/test/resume.md', '# resume')

    Leter::Website.new.build

    index = Leter::IO.read_file('tmp/test/index.html')
    resume = Leter::IO.read_file('tmp/test/resume/index.html')

    assert(index)
    assert(resume)

    assert_equal('resume', Leter::Html.new(resume).title)
  end

  # build a single file with a pattern
  def test_build_single
    Leter::IO.save_file('tmp/test/Working in Silicon Valley.md', '# SV')
    Leter::IO.save_file('tmp/test/Building a WFH shed.md', '# WFH')

    Leter::Website.new.build('wfh')

    sv = Leter::IO.read_file('tmp/test/working-in-silicon-valley/index.html') rescue nil
    shed = Leter::IO.read_file('tmp/test/building-a-wfh-shed/index.html') 

    assert_nil(sv)
    assert(shed)
  end

  def test_index_catalog
    Leter::IO.save_file('blog/news.md', '# news')
    Leter::IO.save_file('blog/vim_tips.md', '# vim tips')

    Leter::Website.new.build

    blog_index = Leter::IO.read_file('blog/index.html')

    assert(blog_index)
  end

  def test_index_item_date
    Leter::IO.save_file('blog/vim_tips.md', '# vim tips')

    Leter::Website.new.build

    blog_index = Leter::IO.read_file('blog/index.html')

    html = Leter::Html.new(blog_index)

    index_item_updated_at = html.parser.at_css('span.updated_at').text.strip

    updated_at = Date.today.strftime(Leter::DATE_FORMAT) + ' –'

    assert_equal(updated_at, index_item_updated_at)
  end

  def test_index_item_no_date
    Leter::IO.save_file('blog/vim_tips.md', '# vim tips')

    config = Leter::AccountConfig.new

    Leter::Website.new(config).build

    blog_index = Leter::IO.read_file('blog/index.html')

    html = Leter::Html.new(blog_index)

    index_item_updated_at = html.parser.at_css('div#updated_at')

    assert_nil(index_item_updated_at)
  end

  def test_clean
    index_md = 'tmp/clean/site/index.md'
    resume_md = 'tmp/clean/site/resume.md'
    docker_tutorial_md = 'tmp/clean/site/blog/docker_tutorial.md'

    Leter::IO.save_file(index_md, '# index')
    Leter::IO.save_file(resume_md, '# resume')
    Leter::IO.save_file(docker_tutorial_md, '# docker tutorial')

    Leter::Website.new.tap do |w|
      w.build
      w.clean
    end

    assert_empty(Dir['tmp/clean/site/**/*.html'])
  end

  def test_add_date
    Leter::IO.save_file('tmp/test/resume.md', '# resume')

    Leter::Website.new.build

    resume = Leter::IO.read_file('tmp/test/resume/index.html')

    assert(Leter::Html.new(resume).date)
  end

  def test_dont_add_date
    Leter::IO.save_file('tmp/test/index.md', '# main page')

    Leter::Website.new.build

    index = Leter::IO.read_file('tmp/test/index.html')

    assert_nil(Leter::Html.new(index).date)
  end

  def test_custom_page_config
    Leter::IO.save_file('blog/vim_tips.md', '# vim tips')
    custom = { blog: { 'vim-tips': { theme: 'crest' } } }

    config = Leter::AccountConfig.new(theme: 'banana', custom: custom)
    Leter::Website.new(config).build

    blog_post = Leter::IO.read_file('blog/vim-tips/index.html')

    assert_equal('crest', Leter::Html.new(blog_post).theme_name)
  end
end
