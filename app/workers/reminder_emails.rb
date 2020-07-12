class ReminderEmails
    include Sidekiq::Worker

    def perform
        User.all.each do |u|
            remind_steps = u.next_steps_to_remind_at_time(Time.now)
            next if remind_steps.empty?
            UserTopicItem.transaction do
                remind_steps.keys.each do |topic_id|
                    ut = UserTopicItem.where(user_id: u.id, topic_id: topic_id).first
                    ut.last_reminder = Time.now
                    ut.save!
                end
                TopicReminderMailer.with(remind_topics: remind_steps, user_id: u.id).merged_reminder.deliver
            end
        end

        ss = Sidekiq::ScheduledSet.new
        ss.each { |job| job.delete if job.klass == 'ReminderEmails' }
        ReminderEmails.perform_in(10.minutes)
    end
end
