require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get dashboard" do
    get :dashboard
    assert_response :success
  end

  test "should get setting" do
    get :setting
    assert_response :success
  end

end
