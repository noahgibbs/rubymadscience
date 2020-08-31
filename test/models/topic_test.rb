require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    Topic.topic_root = File.join(Rails.root, "app/models/topics")
  end

  test "All production Topic JSON parses as Topics" do
    Topic.all.each do |topic|
      topic.steps.each do |step|
        # Don't need to do anything - it'll have parsed or not by this point.
      end
      (topic.data["related"] || []).each do |rel_topic_id|
      end
    end
  end
end
