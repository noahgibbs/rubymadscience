class ReminderEmails
    include Sidekiq::Worker

    def perform
        start_time = Time.current
        today = start_time.beginning_of_day

        Event.create!(typeof: "doReminderEmails", data: {})

        reminderless_users = User.joins("LEFT OUTER JOIN user_reminders ON user_reminders.user_id = users.id").where("user_reminders.user_id IS null")
        reminderless_users.each do |u|
            Event.create! typeof: "userSetReminder", user_id: u.id
            u.create_user_reminder!(reminder_time: start_time, last_reminder: start_time - 10.years)
        end

        last_reminder_time = start_time.advance(days: -1)
        remind_users = User.where.not(confirmed_at: nil).joins("JOIN user_reminders ON user_reminders.user_id = users.id").where("user_reminders.last_reminder < ?", last_reminder_time)
        remind_users.each do |u|
            remind_steps = u.next_steps_to_remind_on_day(today)

            urd = u.user_reminder
            urd.last_reminder = start_time
            urd.save!
            next if remind_steps.empty?

            Event.create! typeof: "sendEmail", user_id: u.id, data: { remind_topics: remind_steps }
            TopicReminderMailer.with(remind_topics: remind_steps, user_id: u.id).merged_reminder.deliver
        end

        ReminderEmails.perform_in(10.minutes)
    end
end
