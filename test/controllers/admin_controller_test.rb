require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should redirect to login if not logged in" do
    get admin_dashboard_url
    assert_response :redirect
  end

  test "should not get dashboard if logged in as non-admin" do
    sign_in users(:reminder_tester)
    get admin_dashboard_url
    assert_response :forbidden
  end

  test "should get dashboard if logged in as admin" do
    sign_in users(:admin)
    get admin_dashboard_url
    assert_response :success
  end

end
