require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get tags" do
    get repositories_tags_url
    assert_response :success
  end

  test "should get settings" do
    get repositories_settings_url
    assert_response :success
  end

  test "should get collaborators" do
    get repositories_collaborators_url
    assert_response :success
  end

  test "should get new" do
    get repositories_new_url
    assert_response :success
  end

  test "should get show" do
    get repositories_show_url
    assert_response :success
  end

  test "should get update" do
    get repositories_update_url
    assert_response :success
  end

  test "should get destroy" do
    get repositories_destroy_url
    assert_response :success
  end

end
