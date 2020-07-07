require 'test_helper'

class UserCreationAndValidationTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test "Can see login info" do
        get "/"  # No error on the index
        assert_select ".login-info a", "sign up"
    end

    test "Can log in as existing user" do
        get new_user_session_url
        assert_response :success

        post user_session_url,
            params: {
                user: {
                    email: "the.codefolio.guy+rms@gmail.com",
                    password: "password"
                }
            }
        assert_response :success
    end


end
