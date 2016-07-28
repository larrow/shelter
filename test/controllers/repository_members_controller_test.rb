require 'test_helper'

class RepositoryMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get repository_members_index_url
    assert_response :success
  end

  test "should get new" do
    get repository_members_new_url
    assert_response :success
  end

  test "should get destroy" do
    get repository_members_destroy_url
    assert_response :success
  end

  test "should get toggle_access_level" do
    get repository_members_toggle_access_level_url
    assert_response :success
  end

end
