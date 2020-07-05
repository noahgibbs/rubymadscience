class AddTopicIdToUserStepItems < ActiveRecord::Migration[6.0]
  def change
    add_column :user_step_items, :topic_id, :string
    UserStepItem.reset_column_information

    UserStepItem.all.each do |us|
        us.topic_id = us.step_id.split("/", 2)[0]
        us.save!
    end
    UserStepItem.reset_column_information
  end
end
