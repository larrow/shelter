require 'test_helper'

class ServiceControllerTest < ActionDispatch::IntegrationTest
  test "should get notifications" do
    get service_notifications_url
    assert_response :success
  end

  test "should get token" do
    get service_token_url
    assert_response :success
  end

end
