class UserMailer < ApplicationMailer
  def registration(user)
    @user = user
    mail(:to => "#{user.first + ' ' + user.last} <#{user.email}>", :subject => "Registration Confirmation")
  end

  def invite(user, email_hash, message, prev_gen)
    @user = user
    @message = message
    ct = email_hash.keys.length - 1
    (0..ct).each do |e|
      e = e.to_s
      addr = email_hash[e]
      new_user = User.find_or_create_by(email: addr)
      # no password error upon first creation lets us know they're not in the system
      if !new_user.errors.messages.empty?
        @new = new_user
        @new.password = 'placeholder'
        @new.generation = prev_gen + 1
        @new.save
        mail(:to => email_hash[e],
             :subject => "Carbon Collective Invite from #{@user.first}"
            )
      # email in system but unregistered, resend to recipient
      elsif !new_user.email_confirmed
        @new = new_user
        @new.generation = prev_gen + 1
        mail(:to => email_hash[e],
             :subject => "Carbon Collective Invite from #{@user.first}"
            )
      else
        #person already in the system
        nil
      end
    end
  end
end
