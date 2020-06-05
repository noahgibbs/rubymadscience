$("body").on("change", "select.done-select", function() {
    console.log("Got into done-select handler")

    var changed_elt = $(this);
    var step_id = changed_elt.data("step-id");

    // Disable the selector until the request finishes
    changed_elt.prop('disabled', true);

    $.ajax("/steps/update_done", {
        method: 'post',
        data: {
            step_id: step_id,
            done: this.value,
            note: "..."
        },
        success: function() {
            console.log("Success...");
            $("#select-error-box-" + step_id).text("");
            changed_elt.prop('disabled', false);
            console.log("Yup, got here...")
        },
        error: function() {
            console.log("Failure...");
            $("#select-error-box-" + step_id).text("(Server error)");
            changed_elt.prop('disabled', false);
        }
    });
});
