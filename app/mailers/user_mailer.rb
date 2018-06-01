class UserMailer < ApplicationMailer
  def registration(user)
    @user = user
    mail(:to => "#{user.first + ' ' + user.last} <#{user.email}>", :subject => "Registration Confirmation")
  end

  def invite(user, email_hash)
    @user = user
    ct = email_hash.keys.length - 1
    (0..ct).each do |e|
      e = e.to_s
      mail(:to => email_hash[e],
           :subject => "Carbon Collective Invite from #{@user.first}"
          )
    end
  end
end
