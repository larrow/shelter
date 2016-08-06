require 'test_helper'

class Admin::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_repositories_index_url
    assert_response :success
  end

end
