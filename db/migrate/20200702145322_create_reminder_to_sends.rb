class CreateReminderToSends < ActiveRecord::Migration[6.0]
  def change
    create_table :reminder_to_sends do |t|
      t.integer :user_id
      t.datetime :when
      t.string :topics
      t.string :data

      t.timestamps
    end
  end
end
