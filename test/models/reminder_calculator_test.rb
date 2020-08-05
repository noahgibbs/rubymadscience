require 'test_helper'
require 'time'

class SimpleReminder
    include ReminderCalculator
end

class ReminderCalculatorTest < ActiveSupport::TestCase
    setup do
        @calc = SimpleReminder.new
        Topic.topic_root = File.join(Rails.root, "test", "topic_data")
        @topic_subs = {
            "topic_daily" => {
                frequency: "daily",
            },
            "topic_weekly" => {
                frequency: "weekly",
            },
            "topic_monthly" => {
                frequency: "monthly",
            },
            "topic_none" => {
                frequency: "none",
            },
        }
    end

    test "send only dailies after one day" do
        reminder_origin = Time.parse("2020-07-01 16:32")
        reminder_day = Time.parse("2020-07-02 17:37")

        ttr = @calc.topics_to_remind_on_day(@topic_subs, reminder_origin, reminder_day)
        assert_equal ["topic_daily"], ttr
    end

    test "send dailies and weeklies after one week" do
        reminder_origin = Time.parse("2020-07-01 16:32")
        reminder_day = Time.parse("2020-07-08 17:37")

        ttr = @calc.topics_to_remind_on_day(@topic_subs, reminder_origin, reminder_day)
        assert_equal ["topic_daily", "topic_weekly"], ttr
    end

    test "find next steps for topics" do
        topic_ids = ["coding_studies", "rails_internals", "software_practice"]
        step_completions = [
            UserStepItem.all.build(topic_id: "coding_studies", step_id: "coding_studies/rubyconf-conscious-coding-practice"),
            UserStepItem.all.build(topic_id: "coding_studies", step_id: "coding_studies/a-simple-coding-exercise"),
            UserStepItem.all.build(topic_id: "rails_internals", step_id: "rails_internals/2"),
            UserStepItem.all.build(topic_id: "software_practice", step_id: "software_practice/practice-deeply-and-consciously"),
            UserStepItem.all.build(topic_id: "software_practice", step_id: "software_practice/single-idea-with-time-limit"),
            UserStepItem.all.build(topic_id: "software_practice", step_id: "software_practice/fear-of-wasted-practice-time"),
            UserStepItem.all.build(topic_id: "software_practice", step_id: "software_practice/how-to-commit-to-mastery"),
        ]
        ns = @calc.next_step_by_topic_id(topic_ids, step_completions)
        assert_equal({
            "coding_studies" => "coding_studies/ascii-art-faces",
            "rails_internals" => "rails_internals/1",
        }, ns)
    end
end
