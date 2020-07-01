require "sidekiq/api"

ss = Sidekiq::ScheduledSet.new

# Make sure we have exactly one ReminderEmails job queued.
# Start it quickly after boot to send off any overdue reminders.

ss.each { |job| job.delete if job.klass == 'ReminderEmails' }
ReminderEmails.perform_in(3.minutes)

# With multiple processes, we might accidentally get multiple ReminderEmails jobs.
# That's not perfect but not a big deal.
