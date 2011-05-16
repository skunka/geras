require 'test_helper'

class MonitorsControllerTest < ActionController::TestCase
  test "should get application" do
    get :application
    assert_response :success
  end

  test "should get database" do
    get :database
    assert_response :success
  end

  test "should get web" do
    get :web
    assert_response :success
  end

end
