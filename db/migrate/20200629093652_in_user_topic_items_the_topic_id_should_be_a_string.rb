class InUserTopicItemsTheTopicIdShouldBeAString < ActiveRecord::Migration[6.0]
  def change
    change_column :user_topic_items, :topic_id, :string
  end
end
