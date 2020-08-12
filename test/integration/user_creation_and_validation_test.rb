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
                    email: "the.codefolio.guy+rubymadscience@rubymadscience.com",
                    password: "password"
                }
            }
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert controller.send(:current_user), "No user was logged in successfully!"
        assert_equal "the.codefolio.guy+rubymadscience@rubymadscience.com", controller.send(:current_user).email
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
        assert controller.send(:current_user), "No user was logged in successfully!"
        assert_equal "newperson@example.com", controller.send(:current_user).email

        new_user = User.where(email: "newperson@example.com").first
        assert new_user, "New user was not created!"
        get "/auth/confirmation", params: { confirmation_token: new_user.confirmation_token }

        assert_response :redirect
        follow_redirect!
        assert_response :success
    end

    test "Unconfirmed user login works" do
        get new_user_registration_url
        assert_response :success

        assert_equal 0, ActionMailer::Base.deliveries.size
        post user_session_url,
            params: {
                user: {
                    email: "the.codefolio.guy+unconfirmed@rubymadscience.com",
                    password: "password",
                    password_confirmation: "password",
                }
            }
        assert_response :redirect
        follow_redirect!
        assert_response :success

        assert controller.send(:current_user), "No user was logged in successfully!"
        assert_equal "the.codefolio.guy+unconfirmed@rubymadscience.com", controller.send(:current_user).email
    end

    test "Resend confirmation works" do
        sign_in users(:unconfirmed)
        get new_user_confirmation_url
        assert_response :success

        assert_equal 0, ActionMailer::Base.deliveries.size
        post user_confirmation_url,
            params: { user: { email: "the.codefolio.guy+unconfirmed@rubymadscience.com" } }
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_select ".field_with_errors", false
        assert_select ".rails-notice", "You will receive an email with instructions for how to confirm your email address in a few minutes."

        assert_equal 1, ActionMailer::Base.deliveries.size
    end

    test "Can delete an existing user" do
        user_id = users(:unconfirmed).id

        sign_in users(:unconfirmed)
        delete user_registration_url
        assert_response :redirect
        follow_redirect!
        assert_response :success

        assert_equal 0, User.where(id: user_id).count
    end

end
