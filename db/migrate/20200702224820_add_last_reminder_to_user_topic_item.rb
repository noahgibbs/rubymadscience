class AddLastReminderToUserTopicItem < ActiveRecord::Migration[6.0]
  def change
    add_column :user_topic_items, :last_reminder, :datetime
  end
end
