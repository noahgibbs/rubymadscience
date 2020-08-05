require "time"

# No reason that the User email reminder logic can't live
# a simple, separate PORO.

# We assume sends happen daily at a given time for each user.

module ReminderCalculator
    # Topics_hash is of the form:
    #    "topic_name" => {
    #        frequency: "weekly",      # Or "daily", "monthly" or "none"
    #    }
    # and also a reminder_time and a last_reminder time. The reminder_time
    # is the 'origin' of the reminders, such as the user's creation or
    # first subscription -- weekly reminders will happen N weeks after this
    # origin, etc.
    def topics_to_remind_on_day(topics_hash, reminder_origin, reminder_day)
        topics = topics_hash.dup
        topics.delete_if { |k, v| v[:frequency] == "none" }

        days_from_origin = (reminder_day.to_date - reminder_origin.to_date).to_i
        return [] if days_from_origin == 0

        topics_to_remind = topics.keys.select do |topic_name|
            topic = topics[topic_name]
            do_include =
                if topic[:frequency] == "daily"
                    true
                elsif topic[:frequency] == "weekly"
                    days_from_origin % 7 == 0
                elsif topic[:frequency] == "monthly"
                    days_from_origin % 30 == 0  # This isn't exactly monthly... :-/
                else
                    raise "Unknown frequency #{topic[:frequency].inspect} for topic #{topic_name.inspect}!"
                end
        end
    end

    # This takes a list of topic_ids and returns only
    # those which, after step_completions, still have at
    # least one unfinished step.

    # This method looks up Topics by ID, which I feel a
    # little odd about. The rationale is that it avoids
    # database objects, but Topic is loaded from a file.
    # That's true, and test-relevant, but it also mixes
    # levels of abstraction. Separating this logic from
    # its models has been messy and could likely be done
    # better.

    # Step_completions is a list of items that look like
    # UserStepItems - they have accessors for topic_id and
    # step_id, and if passed in are assumed to correspond
    # to "yes, this step is complete (or skipped.)"
    def next_step_by_topic_id(topic_ids, step_completions)
        topic_steps = {}
        topic_ids.each do |topic_id|
            topic = Topic.find(topic_id)
            topic_steps[topic_id] = {}
            topic.steps.each do |step|
                topic_steps[topic_id][step.id] = true
            end
        end

        step_completions.each do |completion|
            topic_steps[completion.topic_id].delete(completion.step_id)
        end

        next_by_topic_id = {}
        topic_steps.each do |topic_id, unfinished_steps|
            unless unfinished_steps.empty?
                first_unfinished, t = *unfinished_steps.first
                next_by_topic_id[topic_id] = first_unfinished
            end
        end

        next_by_topic_id
    end
end
