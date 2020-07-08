# app/workers/reminder_emails.rb
class ReminderEmails
    include Sidekiq::Worker

    def perform
        User.each do |u|
            remind_steps = u.next_steps_to_remind_at_time(Time.now)
            TopicReminderMailer.with(remind_topics: remind_steps, user_id: u.id).merged_reminder.deliver_later
        end

        ss = Sidekiq::ScheduledSet.new
        ss.each { |job| job.delete if job.klass == 'ReminderEmails' }
        ReminderEmails.perform_at(Time.now.advance(days: 1).middle_of_day + rand(2000))
    end
end
