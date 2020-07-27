require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get about" do
    get "/about"
    assert_response :success
  end

  test "should get feedback" do
    get "/feedback"
    assert_response :success
  end

  test "should get profile" do
    get "/profile"
    assert_response :success
  end

  test "should see a subscription row for subscribed user" do
    sign_in users(:reminder_tester)
    get "/profile"
    assert_response :success
    assert_select ".profile-topic-row"
  end

  test "should not see a subscription row for a subscription-less user" do
    sign_in users(:unconfirmed)
    get "/profile"
    assert_response :success
    assert_select ".profile_topic_row", false
  end

  test "should not see warnings for confirmed user" do
    sign_in users(:reminder_tester)
    get "/profile"
    assert_response :success
    assert_select ".profile_address_unconfirmed_reminder", false
    assert_select ".profile_reminder_unconfirmed_warning", false
  end

  test "should see warnings for unconfirmed user" do
    sign_in users(:unconfirmed)
    get "/profile"
    assert_select ".profile_address_unconfirmed_reminder b", "WILL NOT"
    assert_select ".profile_reminder_unconfirmed_warning b", "WILL NOT"
  end

end
