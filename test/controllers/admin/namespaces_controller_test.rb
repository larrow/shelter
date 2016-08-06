require 'test_helper'

class Admin::NamespacesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_namespaces_index_url
    assert_response :success
  end

end
