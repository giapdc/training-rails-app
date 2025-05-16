class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: I18n.t("user_mailer.welcome_email.subject"))
  end
end
