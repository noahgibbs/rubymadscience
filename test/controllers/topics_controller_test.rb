require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    get topics_index_url
    assert_response :success
  end

  test "should get index while signed in" do
    sign_in users(:admin)
    get topics_index_url
    assert_response :success
  end

  test "should update a subscription that exists" do
    sign_in users(:reminder_tester)
    post topics_update_subscription_url, params: { topic_id: "coding_studies", subscription: "weekly" }
    assert_response :success
    new_sub = UserTopicItem.where(user_id: users(:reminder_tester).id, topic_id: "coding_studies").first
    assert_equal "weekly", new_sub.subscription
  end

  test "should update a new subscription" do
    sign_in users(:reminder_tester)
    post topics_update_subscription_url, params: { topic_id: "rails_internals", subscription: "weekly" }
    assert_response :success
    new_sub = UserTopicItem.where(user_id: users(:reminder_tester).id, topic_id: "rails_internals").first
    assert_equal "weekly", new_sub.subscription
  end
end
