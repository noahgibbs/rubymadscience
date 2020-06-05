class StepsController < ApplicationController
  # A quiet little AJAX action to update the done-ness of a step for a user
  def update_done
    user_id = current_user.id
    step_id = params[:step_id]
    if user_id && step_id
        usi = UserStepItem.find_or_create_by(user_id: current_user.id, step_id: step_id)
        usi.doneness = params[:done]
        usi.note = params[:note]
        saved = usi.save
    end

    if saved
        render :text => "OK", :layout => nil, :status => 200
    else
        render :status => 404
    end
  end
end
