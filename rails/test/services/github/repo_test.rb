require 'test_helper'

class RepoTest < ActiveSupport::TestCase
  test 'list markdown files' do
    #TODO no hardcoded stuff
    conn = Github::Auth.new.client(645366)

    payload = Github::Payload.new({})
    
    # TODO no hardcoded
    payload.stubs(:repository_name).returns('eduardosasso/leter-test')

    repo = Github::Repo.new(conn, payload)

    files = repo.markdown_files

    assert_equal(files.count, files.count { |f| Markdown.is?(f) })
  end
end
