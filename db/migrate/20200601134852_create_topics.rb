class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.string :desc, length: 4096
      t.json :steps

      t.timestamps
    end
  end
end
