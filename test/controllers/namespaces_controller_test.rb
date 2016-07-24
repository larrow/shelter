require 'test_helper'

class NamespacesControllerTest < ActionDispatch::IntegrationTest
  test "should get teams" do
    get namespaces_teams_url
    assert_response :success
  end

  test "should get settings" do
    get namespaces_settings_url
    assert_response :success
  end

  test "should get create" do
    get namespaces_create_url
    assert_response :success
  end

  test "should get new" do
    get namespaces_new_url
    assert_response :success
  end

  test "should get edit" do
    get namespaces_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get namespaces_destroy_url
    assert_response :success
  end

  test "should get show" do
    get namespaces_show_url
    assert_response :success
  end

end
