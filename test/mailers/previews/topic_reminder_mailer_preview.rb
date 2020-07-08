# Preview all emails at http://localhost:3000/rails/mailers/topic_reminder_mailer
class TopicReminderMailerPreview < ActionMailer::Preview
    def merged_reminder
        rt = {
            "coding_studies" => "coding_studies/rubyconf-conscious-coding-practice",
            "software_practice" => "software_practice/practice-deeply-and-consciously",
        }
        TopicReminderMailer.with(user: User.first, remind_topics: rt).merged_reminder
    end
end
