require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = users(:user_1)
  end
  #
  test "should get index without login" do
    
    get :index, params: {utf8: '✓', q: 'hahah'}
    assert_response :success
    assert_not_nil assigns(:repositories)
  end

  test "should get index with login user" do
    sign_in( @user )
    get :index, params: {utf8: '✓', q: 'hahah'}
    assert_response :success
    assert_not_nil assigns(:repositories)
  end

end
