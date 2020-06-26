module TopicsHelper
    def bootstrap_button_group(options, selected:nil, top_classes: "")
        all_options = options.map { |value, name|
            <<HTML
<label class="btn btn-primary#{ value == selected ? " active" : "" }">
    <input type="radio" data-button-value="#{ value }" autocomplete="off"#{ value == selected ? " checked" : "" } />
    #{name}
</label>
HTML
        }.join("\n")

        h = <<HTML
<div class="btn-group btn-group-toggle #{top_classes}" data-toggle="buttons">
#{all_options}
</div>
HTML
        h.html_safe
    end
end
