require 'test_helper'

class StepsControllerTest < ActionDispatch::IntegrationTest
  test "should get update_done" do
    get steps_update_done_url
    assert_response :success
  end

end
