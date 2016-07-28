require 'test_helper'

class GroupMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get group_members_index_url
    assert_response :success
  end

  test "should get new" do
    get group_members_new_url
    assert_response :success
  end

  test "should get destroy" do
    get group_members_destroy_url
    assert_response :success
  end

  test "should get toggle_access_level" do
    get group_members_toggle_access_level_url
    assert_response :success
  end

end
