# No reason that the User email reminder logic can't live
# a simple, separate PORO.

# For now, this assumes all sends happen at roughly the same time of
# day, so we can mostly count in whole days. Convenient!
#
# Can that condition fail? Absolutely. Bounced mail and server downtime
# are just the first two reasons that come to mind.
module ReminderCalculator
    # Pass in a hash 'topics' of the form:
    #    "topic_name" => {
    #        frequency: "weekly",      # Or "daily", "monthly" or "none"
    #        last_reminder: Time.now,  # Whenever last reminder was for this topic
    #    }
    def topics_to_remind(topics_hash, send_time)
        topics = topics_hash.dup
        topics.delete_if { |k, v| v[:frequency] == "none" }

        topics_to_remind = topics.keys.select do |topic_name|
            topic = topics[topic_name]
            approx_next_reminder = if topic[:frequency] == "daily"
                topic[:last_reminder].advance(days: 1, hours: -2)
            elsif topic[:frequency] == "weekly"
                topic[:last_reminder].advance(weeks: 1, hours: -2)
            elsif topic[:frequency] == "monthly"
                topic[:last_reminder].advance(months: 1, hours: -2)
            else
                raise "Unknown frequency #{topic[:frequency].inspect} for topic #{topic_name.inspect}!"
            end

            # Return true for this topic name if it's time to send again
            approx_next_reminder <= send_time
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
    def unfinished_topics(topic_ids, step_completions)
        topic_steps = {}
        topic_ids.each do |topic_id|
            topic = Topic.find(topic_id)
            topic_steps[topic_id] = {}
            topic.steps.each do |step|
                topic_steps[topic_id][step.id] = false
            end
        end

        step_completions.each do |completion|
            topic_steps[completion.topic_id][completion.step_id] = true
        end

        # Choose only those topic IDs that have at least one unfinished step
        unfinished = topic_steps.keys.select do |topic_id|
            topic_steps[topic_id].any? { |step_id, is_done| is_done == false }
        end

        unfinished
    end
end
