class StepsController < ApplicationController
  # A quiet little AJAX action to update the done-ness of a step for a user
  def update_done
    user_id = current_user.id
    step_id = params[:step_id]
    topic_id = step_id.split("/", 2)[0]
    if user_id && step_id
        usi = UserStepItem.find_or_create_by(user_id: current_user.id, step_id: step_id, topic_id: topic_id)
        usi.doneness = params[:done]
        usi.note = params[:note]
        saved = usi.save
    end

    if saved
        render plain: "OK", layout: nil, status: 200
    else
        render plain: "Not Found", layout: nil, status: 404
    end
  end
end
