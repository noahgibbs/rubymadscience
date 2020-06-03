class AddStepsToTopics < ActiveRecord::Migration[6.0]
  def change
    create_table "steps" do |t|
        t.string  :name, size: 255
        t.integer :topic_id
        t.integer :order
        t.string  :url,  size: 4096
        t.string  :type, size: 16
        t.json    :extra_data

        t.timestamps

        t.index [:topic_id, :order]
    end

    # If we had useful data, this would need to save it. But we don't.
    remove_column :topics, :steps, :json

    # Now there's one called "extra_data" for metadata that doesn't necessarily get a column
    add_column :topics, :extra_data, :json

    add_column :topics, :name, :string, size: 1024
    add_column :topics, :thumbnail_url, :string, size: 4096
    add_column :topics, :comment_url, :string, size: 4096
  end
end
