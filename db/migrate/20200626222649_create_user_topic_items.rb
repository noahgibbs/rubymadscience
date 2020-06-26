class CreateUserTopicItems < ActiveRecord::Migration[6.0]
  def change
    create_table :user_topic_items do |t|
      t.integer :user_id
      t.integer :topic_id
      t.string :subscription

      t.timestamps

      t.index [:user_id, :topic_id], unique: true
    end
  end
end
