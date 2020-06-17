class ChangeStepsAndTopicsToFileNotDb < ActiveRecord::Migration[6.0]
  def change
    change_column :user_step_items, :step_id, :string

    drop_table :steps
    drop_table :topics
  end
end
