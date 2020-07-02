class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :type
      t.string :data
      t.integer :user_id

      t.timestamps
    end
  end
end
