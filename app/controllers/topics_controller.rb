class TopicsController < ApplicationController
  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
    if current_user
        @ut = UserTopicItem.where(user_id: current_user.id, topic_id: @topic.id).first
    end
  end

  def update_subscription
    user = current_user
    return render(plain: "No such user found", status: 404) unless user

    subscription = params[:subscription]  # "none", "daily", "weekly", "monthly"
    return render(plain: "Not a valid subscription value", status: 400) unless UserTopicItem::SUBSCRIPTION_VALUES[subscription]

    success = false
    scope = UserTopicItem.where(user_id: user.id, topic_id: params[:topic_id])
    ut = scope.first
    if ut
        ut.subscription = subscription
        success = ut.save
    else
        ut = scope.create
        success = ut.persisted?
    end

    if success
        render(plain: "OK", status: 200)
    else
        render(plain: "Error saving", status: 500)
    end
  end
end
