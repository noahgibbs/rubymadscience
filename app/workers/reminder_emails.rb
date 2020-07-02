# app/workers/reminder_emails.rb
class ReminderEmails
    include Sidekiq::Worker

    def perform


        ss = Sidekiq::ScheduledSet.new
        ss.each { |job| job.delete if job.klass == 'ReminderEmails' }
        ReminderEmails.perform_at(Time.now.advance(days: 1).middle_of_day + rand(2000))
    end
end
