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

    test "Can sign up as new user" do
        get new_user_registration_url
        assert_response :success

        assert_equal 0, ActionMailer::Base.deliveries.size
        post user_registration_url,
            params: {
                user: {
                    email: "newperson@example.com",
                    password: "newpassword",
                    password_confirmation: "newpassword",
                }
            }

        assert_equal 1, ActionMailer::Base.deliveries.size
        new_message = ActionMailer::Base.deliveries[0]
        assert_equal ["newperson@example.com"], new_message.to
        assert new_message.body.to_s["Confirm my account"], "Message body doesn't contain the string 'Confirm my account'!"

        assert_response :redirect
        follow_redirect!
        assert_response :success

        new_user = User.where(email: "newperson@example.com").first
        assert new_user, "New user was not created!"
        get "/auth/confirmation", params: { confirmation_token: new_user.confirmation_token }

        assert_response :redirect
        follow_redirect!
        assert_response :success
    end
end
