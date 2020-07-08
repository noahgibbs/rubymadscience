require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "check simple topic reminder" do
    reminders = users(:reminder_tester).next_steps_to_remind_at_time(Time.parse("2020-07-20 13:12"))

    assert_equal( { "coding_studies" => "coding_studies/rubyconf-conscious-coding-practice" }, reminders )
  end
end
