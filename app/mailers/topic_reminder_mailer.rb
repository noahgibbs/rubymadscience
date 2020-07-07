class TopicReminderMailer < ApplicationMailer
  def merged_reminder
    @user = params[:user]
    mail(subject: "Your Topics on RubyMadScience.com")
  end
end
