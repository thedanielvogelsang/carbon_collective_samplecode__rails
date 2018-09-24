class UserMailer < ApplicationMailer
  def registration(user)
    @user = user
    mail(:to => "#{user.first + ' ' + user.last} <#{user.email}>", :from => @user.email, :subject => "Registration Confirmation")
  end

  def invite(user, new_user, message)
    @user = user
    @new = new_user
    @message = message
    mail(:to => @new.email,
         :from => @user.email,
         :subject => "Carbon Collective Invite from #{@user.first}"
        )
  end

  def reset_password(user)
    @user = user
    mail(:to => @user.email,
         :from => @user.email,
         :subject => "Carbon Collective reset password confirmation email"
        )
  end
end
