"use strict";

let row_update_handler = function(row_jq_object, step_id, set_value) {
    let row_elt = row_jq_object;
    let done_button_elt = row_elt.find(".mark-doneness-button[data-set-value=2]");
    let skip_button_elt = row_elt.find(".mark-doneness-button[data-set-value=1]");
    let undone_button_elt = row_elt.find(".mark-doneness-button[data-set-value=0]");
    let error_elt = row_elt.find(".select-error-box")

    done_button_elt.prop("disabled", true);
    skip_button_elt.prop("disabled", true);
    undone_button_elt.prop("disabled", true);

    console.log("Updating step " + step_id + " to have done-ness value " + set_value);
    $.ajax("/steps/update_done", {
        method: 'post',
        data: {
            step_id: step_id,
            done: set_value,
            note: ""
        },
        success: function() {
            console.log("Succeeded!");
            error_elt.text("");
            done_button_elt.prop('disabled', set_value != 0)
            skip_button_elt.prop('disabled', set_value != 0)
            undone_button_elt.prop('disabled', set_value == 0)
            row_elt.attr("data-server-value", set_value);
        },
        error: function() {
            console.log("Failed!");
            error_elt.text("(Server error)");
            row_elt.attr("data-server-value", "error");
        }
    });
};

$("body").on("click", ".mark-doneness-button", function (e) {
    let button_elt = $(this);
    let step_id = button_elt.data("step-id");
    let row_obj = button_elt.parents(".step-row");
    let set_value = button_elt.data("set-value");

    row_update_handler(row_obj, step_id, set_value);

    e.preventDefault();
});

let reminder_update_handler = function(e, row_elt) {
    let new_value = row_elt.find("label.active input").data("button-value");
    let topic_id = row_elt.data("topic-id");

    row_elt.find(".btn-group-toggle input").attr("disabled", true);

    console.log("Updating topic " + topic_id + " subscription to have value " + new_value);
    $.ajax("/topics/update_subscription", {
        method: 'post',
        data: {
            topic_id: topic_id,
            subscription: new_value
        },
        success: function() {
            console.log("Succeeded!");
            row_elt.find(".btn-group-toggle input").attr("disabled", false);
            row_elt.find(".subscription-error").text("");
        },
        error: function() {
            console.log("Error setting subscription...");
            row_elt.find(".btn-group-toggle input").attr("disabled", false);
            row_elt.find(".subscription-error").text("Error setting subscription!");
        }
    });
};

$("body").on("click", ".topic-email-reminder-box .btn-group-toggle input", function (e) {
    let row_elt = $(".topic-email-reminder-box");
    return reminder_update_handler(e, row_elt);
});

$("body").on("click", ".profile-topic-row .btn-group-toggle input", function (e) {
    let row_elt = $(this).parents(".profile-topic-row");
    return reminder_update_handler(e, row_elt);
});
