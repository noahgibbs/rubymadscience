class PagesController < ApplicationController
  def about
  end

  def feedback
  end

  def profile
    if current_user
        @topic_items = UserTopicItem.where(user_id: current_user.id).order("topic_id").all
        @topics = @topic_items.map { |ti| Topic.find(ti.topic_id) }
    end
  end
end
