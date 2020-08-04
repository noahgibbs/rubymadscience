require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "check simple topic reminder" do
    assert users(:reminder_tester).user_reminder, "The next_steps_to_remind_on_day method assumes a user_reminders entry exists!"
    reminders = users(:reminder_tester).next_steps_to_remind_on_day(Time.parse("2020-07-20 13:12"))

    assert_equal( { "coding_studies" => "coding_studies/rubyconf-conscious-coding-practice" }, reminders )
  end
end
