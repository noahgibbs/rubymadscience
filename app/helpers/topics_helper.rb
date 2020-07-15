module TopicsHelper
    def email_reminder_button_group(selected:nil)
        options = UserTopicItem::SUBSCRIPTION_VALUES
        all_options = options.map { |value, name|
            <<HTML
<label class="btn btn-primary#{ value == selected ? " active" : "" }">
    <input type="radio" data-button-value="#{ value }" autocomplete="off"#{ value == selected ? " checked" : "" } />
    #{name}
</label>
HTML
        }.join("\n")

        h = <<HTML
<div class="btn-group btn-group-toggle" data-toggle="buttons">
#{all_options}
</div>
HTML
        h.html_safe
    end

    def disqus_url_for_topic_id(topic_id)
        "https://computermadscience.com/topics/#{topic_id}"
    end
end
