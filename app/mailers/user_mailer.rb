class UserMailer < ApplicationMailer
  def account_activate user
    @user = user
    mail to: user.email, subject: t(".subject_mail")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t(".subject_password")
  end
end
