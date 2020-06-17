var row_update_handler = function(row_jq_object, step_id, set_value) {
    var row_elt = row_jq_object;
    var button_elt = row_elt.find(".mark-done-button");
    var selector_elt = row_elt.find("select.done-select");
    var error_elt = row_elt.find(".select-error-box")

    button_elt.prop("disabled", true);
    selector_elt.prop("disabled", true);

    $.ajax("/steps/update_done", {
        method: 'post',
        data: {
            step_id: step_id,
            done: 2,
            note: ""
        },
        success: function() {
            error_elt.text("");
            selector_elt.prop('disabled', false);
            button_elt.prop('disabled', set_value != 0)
            row_elt.attr("data-server-value", set_value);
            selector_elt[0].value = set_value;
        },
        error: function() {
            error_elt.text("(Server error)");
            selector_elt.prop('disabled', false);
            row_elt.attr("data-server-value", "error");
        }
    });
}

$("body").on("change", "select.done-select", function(e) {
    var changed_elt = $(this);
    var step_id = changed_elt.data("step-id");
    var set_value = this.value;
    var row_obj = changed_elt.parents(".step-row");

    row_update_handler(row_obj, step_id, set_value);

    e.preventDefault();
});

$("body").on("click", ".mark-done-button", function (e) {
    var button_elt = $(this);
    var step_id = button_elt.data("step-id");
    var row_obj = button_elt.parents(".step-row");

    row_update_handler(row_obj, step_id, 2); // set_value is 2, or "Done"

    e.preventDefault();
});
