require 'test_helper'

class PayloadTest < ActiveSupport::TestCase
  test 'installation_id' do
    payload = JSON.parse(file_fixture('github_installation.json').read)

    assert(Github::Payload.new(payload).installation_id)
  end

  test 'files_updated' do
    payload = JSON.parse(file_fixture('github_push_update.json').read)

    assert(Github::Payload.new(payload).files_updated.any?)
  end

  test 'repository_name' do
    payload = JSON.parse(file_fixture('github_push_update.json').read)

    assert(Github::Payload.new(payload).repository_name)
  end
end
