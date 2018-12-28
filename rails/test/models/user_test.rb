require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "setup user account" do
    User.create!(email:'test@sss.com', password: 'sdlksdlskd')
    assert_equal(UserAccount.count, 4)
  end
  # test "the truth" do
  #   assert true
  # end
end
