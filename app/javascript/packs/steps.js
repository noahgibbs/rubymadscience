$("body").on("change", "select.done-select", function() {
    var changed_elt = $(this);
    var step_id = changed_elt.data("step-id");
    var set_value = this.value;

    // Disable the selector until the request finishes
    changed_elt.prop('disabled', true);

    $.ajax("/steps/update_done", {
        method: 'post',
        data: {
            step_id: step_id,
            done: set_value,
            note: "..."
        },
        success: function() {
            $("#select-error-box-" + step_id).text("");
            changed_elt.prop('disabled', false);
            changed_elt.parents(".step-row").attr("data-server-value", set_value);
        },
        error: function() {
            $("#select-error-box-" + step_id).text("(Server error)");
            changed_elt.prop('disabled', false);
            changed_elt.parents(".step-row").attr("data-server-value", "error");
        }
    });
});
