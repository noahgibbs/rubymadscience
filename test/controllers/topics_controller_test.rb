require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    get topics_index_url
    assert_response :success
  end

  test "should get index while signed in" do
    #@request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in users(:admin)
    get topics_index_url
    assert_response :success
  end

end
