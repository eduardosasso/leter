require 'test_helper'

class AppTest < ActiveSupport::TestCase
  test 'install' do
    payload = JSON.parse(file_fixture('github_installation.json').read)

    Github::App.new(payload).install

    user = User.first

    assert(user.github_app_install_id.present?)
    assert_equal(user.email, 'eduardo.sasso@gmail.com')
  end

  test 'build files added and updated' do
    payload = JSON.parse(file_fixture('github_push_update_test_repo.json').read)

    res = Github::App.new(payload).build

    # TODO test without hiting github
    assert(res[:push].object.sha)
  end

  test 'setup' do
    # TODO json should be after install hook or something
    payload = JSON.parse(file_fixture('github_push_update_test_repo.json').read)

    res = Github::App.new(payload).setup

    # TODO test without hiting github
    assert(res.object.sha)
  end

  test 'config' do
    payload = JSON.parse(file_fixture('github_push_update_test_repo.json').read)

    # TODO check better way without going to github
    # Github::File.any_instance.stubs(:content).returns(AccountConfig.default.to_yaml)

    config = Github::App.new(payload).send(:config)

    assert_equal(config.theme, 'default')
  end
end
