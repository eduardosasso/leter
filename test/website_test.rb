require 'test_helper'

class WebsiteTest < Minitest::Test
  def teardown
    Leter::IO.delete_all('tmp/test')
  end

  def test_assets_folder_on_build
    # TODO
  end

  def test_simple_build
    Leter::IO.save_file('tmp/test/index.md','#Index')
    Leter::IO.save_file('tmp/test/resume.md','#Resume')

    Leter::Website.new.build


    index = Leter::IO.read_file('tmp/test/index.html')
    resume = Leter::IO.read_file('tmp/test/resume/index.html')

    #TODO should also assert the content
    #maybe extract html parsing from pagebuilder in its own class
    assert(index)
    assert(resume)
  end

  def test_clean
    # TODO
  end
end
