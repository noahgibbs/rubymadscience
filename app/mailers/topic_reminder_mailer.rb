class TopicReminderMailer < ApplicationMailer
  def merged_reminder
    @user = User.find(params[:user_id])
    unless @user
        STDERR.puts "Couldn't find user #{params[:user_id].inspect}"
        return
    end
    @remind_topics = {}
    @topic_frequency = {}
    @url_by_topic = {}
    params[:remind_topics].each do |topic_id, next_step_id|
        topic = Topic.find(topic_id)
        ut = UserTopicItem.where(user_id: @user.id, topic_id: topic_id).first

        # Did a user just cancel? Don't handle that by still sending email but saying they have no sub.
        unless ut.subscription == "none"
            @remind_topics[topic] = topic.steps.detect { |step| step.id == next_step_id }
            @topic_frequency[topic] = ut.subscription
            @url_by_topic[topic] = url_for(controller: :topics, action: :show, id: topic.id) +
                "#" + next_step_id
        end
    end
    mail(#from: "the.codefolio.guy+rubymadscience@gmail.com",
         to: @user.email,
         subject: "Your Scheduled Reminder from RubyMadScience.com")
  end
end
