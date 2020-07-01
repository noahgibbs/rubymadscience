# app/workers/reminder_emails.rb
class ReminderEmails
    include Sidekiq::Worker

    def perform


        ss = Sidekiq::ScheduledSet.new
        ss.each { |job| job.delete if job.klass == 'ReminderEmails' }
        ReminderEmails.perform_in(1.minute)
    end
end
