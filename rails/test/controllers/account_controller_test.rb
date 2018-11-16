require 'test_helper'

class AccountControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get account_index_url
    assert_response :success
  end

  test 'should get new' do
    get account_new_url
    assert_response :success
  end

  test 'should get show' do
    get account_show_url
    assert_response :success
  end
end
