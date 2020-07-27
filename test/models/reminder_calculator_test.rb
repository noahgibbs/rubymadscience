require 'test_helper'
require 'time'

class SimpleReminder
    include ReminderCalculator
end

class ReminderCalculatorTest < ActiveSupport::TestCase
    setup do
        @calc = SimpleReminder.new
        Topic.topic_root = File.join(Rails.root, "test", "topic_data")
    end

    test "reminder frequencies for topics" do
        topics = {
            "topic1" => {
                frequency: "weekly",
                last_reminder: Time.parse("2020-07-20 13:00"),
            },
            "topic2" => {
                frequency: "daily",
                last_reminder: Time.parse("2020-07-20 13:00"),
            },
            "topic3" => {
                frequency: "monthly",
                last_reminder: Time.parse("2020-07-20 13:00"),
            },
            "topic4" => {
                frequency: "daily",
                last_reminder: Time.parse("2020-07-21 13:00"),
            },
            "topic5" => {
                frequency: "weekly",
                last_reminder: Time.parse("2020-07-13 13:00"),
            },
            "topic6" => {
                frequency: "monthly",
                last_reminder: Time.parse("2020-06-13 13:00"),
            },
        }
        checked_time = Time.parse("2020-07-21 16:32")

        ttr = @calc.topics_to_remind(topics, checked_time)
        assert_equal ["topic2", "topic5", "topic6"], ttr
    end

    test "next steps for topics" do
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
