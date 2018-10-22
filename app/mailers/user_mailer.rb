class UserMailer < ApplicationMailer
  def registration(user)
    @user = user
    mail(:to => "#{user.first + ' ' + user.last} <#{user.email}>", :from => @user.email, :subject => "Registration Confirmation")
  end

  def invite(user, new_user, message)
    @user = user
    @new = new_user
    @message = message
    puts message == '' ? true : false)
    puts @message
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

  def invite_signup_successful(invite)
    @invite = invite
    @user = invite.parent
    mail(:to => @user.email,
         :from => "carboncollective.devops@gmail.com",
         :subject => "Your Carbon Collective invite has completed their signup!"
       )
  end

  def invite_signup_unsuccessful(invite)
    @invite = invite
    @user = invite.parent
    mail(:to => @user.email,
         :from => "carboncollective.devops@gmail.com",
         :subject => "Your Carbon Collective invite couldn't signup!"
       )
  end
end
