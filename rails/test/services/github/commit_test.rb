require 'test_helper'

class Github::CommitTest < ActiveSupport::TestCase
  test 'push' do
    #TODO, test push files to github
    payload = JSON.parse(file_fixture('github_file_contents.json').read)
  end
end
