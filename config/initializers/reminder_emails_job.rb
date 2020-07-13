require "sidekiq/api"

require_relative "../../app/workers/reminder_emails"

ss = Sidekiq::ScheduledSet.new

# Make sure we have exactly one ReminderEmails job queued.
# Start it quickly after boot to send off any overdue reminders.

num_reminder_jobs = ss.count { |job| job.klass == 'ReminderEmails' }
if num_reminder_jobs == 0
  ReminderEmails.perform_in(3.minutes)
elsif num_reminder_jobs == 1
  # Fine, no change
else
  ss.each { |job| job.delete if job.klass == 'ReminderEmails' }
  ReminderEmails.perform_in(3.minutes)
end

# With multiple processes, we might accidentally get multiple ReminderEmails jobs.
# That's not perfect but not a big deal. It's why I use transactions for some parts
# of the job, though! There's almost certainly some way to coordinate, probably via
# Redis, to avoid the problem.

