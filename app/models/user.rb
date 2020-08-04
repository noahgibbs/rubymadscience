class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  # Note that neither Topic nor Step is an ActiveRecord model.
  # Step isn't even a Ruby object, just a name.
  has_many :user_step_items
  has_many :user_topic_items

  has_one :user_reminder

  include ReminderCalculator

  def is_admin?
    return false unless self.confirmed_at
    return true if self.email == "the.codefolio.guy+rms@gmail.com"
    return true if Rails.env.test? && self.email == "the.codefolio.guy+rubymadscience@rubymadscience.com"

    false
  end

  # Get the list of topic IDs that this user will want to be
  # reminded about as of send-time t, assuming it has been a full
  # day since last reminder.
  def next_steps_to_remind_on_day(t)
    topic_items = self.user_topic_items

    topics = {}
    topic_items.each do |item|
        topics[item.topic_id] = {
            frequency: item.subscription
        }
    end

    ur = self.user_reminder
    due_topics = self.topics_to_remind_on_day(topics, ur.reminder_time, t)

    # We don't remind on topics that are done. Which of these topics is the user already done with?

    # First, get all step items for this user that are done or skipped
    step_items = self.user_step_items.where(topic_id: due_topics, doneness: [1, 2])

    next_step_by_topic_id = self.next_step_by_topic_id(due_topics, step_items)
  end
end
