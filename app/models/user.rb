class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  # Note that neither Topic nor Step is an ActiveRecord model.
  # Step isn't even a Ruby object, just a name.
  has_many :user_step_items
  has_many :user_topic_items

  include ReminderCalculator

  # Get the list of topic IDs that this user will want to be
  # reminded about as of send-time t
  def topics_to_remind_at_time(t)
    topic_items = self.user_topic_items

    topics = {}
    topic_items.each do |item|
        topics[item.topic_id] = {
            frequency: item.subscription,
            last_reminder: item.last_reminder ? item.last_reminder : (Time.now - 10.years),
        }
    end

    due_topics = self.topics_to_remind(topics, t)

    # We don't remind on topics that are done. Which of these topics is the user already done with?

    # First, get all relevant step items for this user
    step_items = self.user_step_items.where(topic_id: due_topics, doneness: [1, 2])

    unfinished_topics = self.unfinished_topics(due_topics, step_items)
  end
end
