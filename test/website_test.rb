require 'test_helper'

class WebsiteTest < Minitest::Test
  def test_assets_folder_on_build
    # TODO
  end

  def test_simple_build
    # TODO
    # write two files index.md and resume.md
    # test should assert two html files have been created
Leter::IO.save_file('tmp/test/index.md','#Index')
  end

  def test_clean
    # TODO
  end
end
