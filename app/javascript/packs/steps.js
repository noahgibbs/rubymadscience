let row_update_handler = function(row_jq_object, step_id, set_value) {
    let row_elt = row_jq_object;
    let done_button_elt = row_elt.find(".mark-doneness-button[data-set-value=2]");
    let skip_button_elt = row_elt.find(".mark-doneness-button[data-set-value=1]");
    let undone_button_elt = row_elt.find(".mark-doneness-button[data-set-value=0]");
    let error_elt = row_elt.find(".select-error-box")

    done_button_elt.prop("disabled", true);
    skip_button_elt.prop("disabled", true);
    undone_button_elt.prop("disabled", true);

    $.ajax("/steps/update_done", {
        method: 'post',
        data: {
            step_id: step_id,
            done: set_value,
            note: ""
        },
        success: function() {
            error_elt.text("");
            done_button_elt.prop('disabled', set_value != 0)
            skip_button_elt.prop('disabled', set_value != 0)
            undone_button_elt.prop('disabled', set_value == 0)
            row_elt.attr("data-server-value", set_value);
        },
        error: function() {
            error_elt.text("(Server error)");
            row_elt.attr("data-server-value", "error");
        }
    });
}

$("body").on("click", ".mark-doneness-button", function (e) {
    let button_elt = $(this);
    let step_id = button_elt.data("step-id");
    let row_obj = button_elt.parents(".step-row");
    let set_value = button_elt.data("set-value");

    row_update_handler(row_obj, step_id, set_value); // set_value is 2, or "Done"

    e.preventDefault();
});
