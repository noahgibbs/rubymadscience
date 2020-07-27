class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  def dashboard
    @user_count = User.count

    @last_email = UserTopicItem.maximum(:last_reminder)
  end

  protected

  def admin_only
    unless current_user && current_user.is_admin?
      return render plain: "You're not an administrative user.", status: 403
    end
  end
end
