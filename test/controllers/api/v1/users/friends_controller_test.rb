require 'test_helper'

class Api::V1::Users::FriendsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_users_friends_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_users_friends_show_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_users_friends_create_url
    assert_response :success
  end

  test "should get edit" do
    get api_v1_users_friends_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get api_v1_users_friends_destroy_url
    assert_response :success
  end

end
