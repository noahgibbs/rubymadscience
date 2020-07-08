class TopicsController < ApplicationController
  def index
    @topics = Topic.all.sort_by { |t| t.id }
  end

  def show
    @topic = Topic.find(params[:id])
    if current_user
        step_ids = @topic.steps.map(&:id)
        @ut = UserTopicItem.where(user_id: current_user.id, topic_id: @topic.id).first
        us = UserStepItem.where(user_id: current_user.id, step_id: [step_ids]).all
        @step_item_by_id = {}
        us.each { |step_item| @step_item_by_id[step_item.step_id] = step_item }
    end
  end

  def update_subscription
    user = current_user
    return render(plain: "No such user found! Are you logged in?", status: 404) unless user

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
        ut.subscription = subscription
        success = ut.save
    end

    if success
        render(plain: "OK", status: 200)
    else
        render(plain: "Error saving", status: 500)
    end
  end
end
