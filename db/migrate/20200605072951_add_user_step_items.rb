class AddUserStepItems < ActiveRecord::Migration[6.0]
  def change
    create_table "user_step_items" do |t|
        t.integer :doneness
        t.string  :note
        t.integer :user_id
        t.integer :step_id

        t.index [:user_id, :step_id]
    end
  end
end
