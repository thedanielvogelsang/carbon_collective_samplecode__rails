class UserMailer < ApplicationMailer
  def registration(user)
    @user = user
    mail(:to => "#{user.first + ' ' + user.last} <#{user.email}>", :subject => "Registration Confirmation")
  end
end
