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
        # Don't need to do anything - it'll have parsed or not by this point.
    end
  end
end
