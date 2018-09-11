class MailerHelper
  def self.invite(user, emails, message, prev_gen)
    emails.keys.each do |key|
      addr = emails[key]
      unless addr == "" || addr == nil
        new_user = User.find_or_create_by(email: addr)
          # no password error upon first creation lets us know they're not in the system
          if !new_user.errors.messages.empty?
            new_user.password = 'placeholder'
            new_user.generation = prev_gen + 1
            new_user.save
            UserInvite.find_or_create_by(user_id: user.id, invite_id: new_user.id)
            UserMailer.invite(user, new_user, message).deliver_now
          # email in system but unregistered, resend to recipient
          elsif !new_user.email_confirmed
            new_user.generation = prev_gen + 1
            new_user.save
            UserInvite.find_or_create_by(user_id: user.id, invite_id: new_user.id)
            UserMailer.invite(user, new_user, message).deliver_now
          else
            #person already in the system
            nil
          end
      end
    end
  end

  def self.sort_emails(emails)
    ct = emails.keys.length - 1
    invited_yet = (0..ct).map do |e|
        e = e.to_s
        addr = emails[e]
        if addr != "" && addr != nil
        u = User.find_by(email: addr)
        u.email_confirmed ? u.email : nil
        end
    end
    if invited_yet.compact.empty?
      message = 'success'
    else
      message = invited_yet.compact
    end
    message
  end

end
