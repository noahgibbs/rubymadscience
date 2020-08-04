class CreateUserReminder < ActiveRecord::Migration[6.0]
  def change
    create_table :user_reminders do |t|
        t.datetime :reminder_time  # Time of day for reminder, plus date of 'origin' for weekly/monthly
        t.datetime :last_reminder  # What day did we last check, and/or send a reminder?
        t.integer  :user_id

        t.timestamps
    end
  end
end
