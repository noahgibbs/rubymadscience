require "test_helper"

class ReminderEmailsTest < ActiveSupport::TestCase
    def emails_with_receiver(recv)
        ActionMailer::Base.deliveries.select { |msg| msg.to.include?(recv) }
    end

    test "should email or not email basic user types" do
        re = ReminderEmails.new
        re.perform # Perform once, right now

        # Unconfirmed user? No email.
        assert_empty emails_with_receiver(users(:unconfirmed).email)

        # Unconfirmed user with reminders? No email.
        assert_empty emails_with_receiver(users(:unconfirmed_with_reminders).email)

        # Confirmed user with no reminders? No email.
        assert_empty emails_with_receiver(users(:confirmed_with_no_reminders).email)

        # Confirmed user with reminders? Email.
        assert_equal 1, emails_with_receiver(users(:reminder_tester).email).size
    end
end
