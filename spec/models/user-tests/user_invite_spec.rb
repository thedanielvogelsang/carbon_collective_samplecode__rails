require 'rails_helper'

RSpec.describe UserInvite, type: :model do
  context 'user invites someone new' do
    it 'it initializes' do
      ui = UserInvite.create(user_id: 1, invite_id: 2)
      expect(ui).to be_present
    end
    # MailerWorker is linked to a Mailer, which errors the test. Comment out UserMailer calls in MailerWorker to test.
    xit 'and it works' do
      user = User.create(email: 'user@gmail.com', password: 'password', first: 'D', last: 'V', generation: 1)
      MailerWorker.invite(user,
                            {"0" => 'new_user123@gmail.com'},
                            'Hey man, you should join this app!',
                            1
                         )
      u_invite = UserInvite.last
        expect(u_invite.user_id).to eq(user.id)
        expect(User.find(u_invite.invite_id).email).to eq("new_user123@gmail.com")
    end
  end
end
