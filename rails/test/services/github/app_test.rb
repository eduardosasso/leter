require 'test_helper'

class AppTest < ActiveSupport::TestCase
  test 'install' do
    payload = JSON.parse(file_fixture('github_installation.json').read)

    Github::App.new(payload).install

    user = User.first

    assert(user.github_app_install_id.present?)
    assert_equal(user.email, 'eduardo.sasso@gmail.com')
  end

  test 'build' do
    payload = JSON.parse(file_fixture('github_push_update_test_repo.json').read)

    Github::App.new(payload).build
  end
end
