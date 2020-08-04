class RemoveLastReminderFromUserTopicItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_topic_items, :last_reminder, :datetime
  end
end
